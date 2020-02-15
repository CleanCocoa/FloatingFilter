/*
 <https://github.com/seanoshea/FuzzyMatchingSwift/>

 Copyright 2016 Sean O'Shea

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 */

import Foundation

/**
 Allows client code to pass parameters to the `fuzzyMatchPattern` calls.
 */
struct FuzzyMatchOptions {
  // defines how strict you want to be when fuzzy matching. A value of 0.0 is equivalent to an exact match. A value of 1.0 indicates a very loose understanding of whether a match has been found.
  var threshold:Double = FuzzyMatchingOptionsDefaultValues.threshold.rawValue
  // defines where in the host String to look for the pattern
  var distance:Double = FuzzyMatchingOptionsDefaultValues.distance.rawValue

  /**
   Standard initializer.
   */
  init() {

  }

  /**
   Initializer which defines `threshold` and `distance` parameters.

   - parameter threshold: The threshold value to set
   - parameter distance:  The distance value to set
   - returns: An instance of `FuzzyMatchOptions`
   */
  init(threshold: Double, distance: Double) {
    self.threshold = threshold
    self.distance = distance
  }
}

/**
 Defines constants which are used if no `options` parameters are passed to `fuzzyMatchPattern` calls.
 */
enum FuzzyMatchingOptionsDefaultValues : Double {
  // Default threshold value. Defines how strict you want to be when fuzzy matching. A value of 0.0 is equivalent to an exact match. A value of 1.0 indicates a very loose understanding of whether a match has been found.
  case threshold = 0.5
  // Default distance value. Defines where in the host String to look for the pattern.
  case distance = 1000.0
}

/**
 Allows for fuzzy matching to happen on Strings
 */
extension String {

  /**
   Provides a confidence score relating to how likely the pattern is to be found in the host string.

   - parameter pattern: The pattern to search for.
   - parameter loc: The index in the element from which to search.
   - parameter distance: Determines how close the match must be to the fuzzy location. See `loc` parameter.
   - returns: A Double which indicates how confident we are that the pattern can be found in the host string. A low value (0.001) indicates that the pattern is likely to be found. A high value (0.999) indicates that the pattern is not likely to be found
   */
  func confidenceScore(_ pattern:String, loc:Int? = 0, distance:Double? = FuzzyMatchingOptionsDefaultValues.distance.rawValue) -> Double? {
    // start at a low threshold and work our way up
    for index in stride(from: 1, to: 1000, by: 1) {
      let threshold:Double = Double(Double(index) / Double(1000))
      var d = FuzzyMatchingOptionsDefaultValues.distance.rawValue
      if let unwrappedDistance = distance {
        d = unwrappedDistance
      }
      let options = FuzzyMatchOptions.init(threshold: threshold, distance: d)
      if self.fuzzyMatchPattern(pattern, loc: loc, options: options) != nil {
        return threshold
      }
    }
    return nil
  }

  /**
   Executes a fuzzy match on the String using the `pattern` parameter.

   - parameter pattern: The pattern to search for.
   - parameter loc: The index in the element from which to search.
   - parameter options: Dictates how the search is executed. See `FuzzyMatchingOptionsParams` and `FuzzyMatchingOptionsDefaultValues` for details.
   - returns: An Int indicating where the fuzzy matched pattern can be found in the String.
   */
  func fuzzyMatchPattern(_ pattern:String, loc:Int? = 0, options:FuzzyMatchOptions? = nil) -> Int? {
    guard count > 0 else { return nil }
    let generatedOptions = generateOptions(options)
    let location = max(0, min(loc ?? 0, count))
    let threshold = generatedOptions.threshold
    let distance = generatedOptions.distance

    if caseInsensitiveCompare(pattern) == ComparisonResult.orderedSame {
      return 0
    } else if pattern.isEmpty {
      return nil
    } else {
      if (location + pattern.count) < count {
        let substring = self[self.index(self.startIndex, offsetBy: 0)...self.index(self.startIndex, offsetBy: pattern.count)]
        if pattern.caseInsensitiveCompare(substring) == ComparisonResult.orderedSame {
          return location
        } else {
          return matchBitapOfText(pattern, loc:location, threshold:threshold, distance:distance)
        }
      } else {
        return matchBitapOfText(pattern, loc:location, threshold:threshold, distance:distance)
      }
    }
  }

  func matchBitapOfText(_ pattern:String, loc:Int, threshold:Double, distance:Double) -> Int? {
    let alphabet = matchAlphabet(pattern)
    let bestGuessAtThresholdAndLocation = speedUpBySearchingForSubstring(pattern, loc:loc, threshold:threshold, distance:distance)
    var scoreThreshold = bestGuessAtThresholdAndLocation.threshold
    var bestLoc = bestGuessAtThresholdAndLocation.bestLoc

    let matchMask = 1 << (pattern.count - 1)
    var binMin:Int
    var binMid:Int
    var binMax = pattern.count + count
    var rd:[Int?] = [Int?]()
    var lastRd:[Int?] = [Int?]()
    bestLoc = NSNotFound
    for (index, _) in pattern.enumerated() {
      binMin = 0
      binMid = binMax
      while binMin < binMid {
        let score = bitapScoreForErrorCount(index, x:(loc + binMid), loc:loc, pattern:pattern, distance:distance)
        if score <= scoreThreshold {
          binMin = binMid
        } else {
          binMax = binMid
        }
        binMid = (binMax - binMin) / 2 + binMin
      }
      binMax = binMid
      var start = maxOfConstAndDiff(1, b:loc, c:binMid)
      let finish = min(loc + binMid, count) + pattern.count
      rd = [Int?](repeating: 0, count: finish + 2)
      rd[finish + 1] = (1 << index) - 1
      var j = finish
      for _ in stride(from: j, to: start - 1, by: -1) {
        var charMatch:Int
        if count <= j - 1 {
          charMatch = 0
        } else {
          let character = String(self[self.index(startIndex, offsetBy: j - 1)])
          if count <= j - 1 || alphabet[character] == nil {
            charMatch = 0
          } else {
            charMatch = alphabet[character]!
          }
        }
        if index == 0 {
          rd[j] = ((rd[j + 1]! << 1) | 1) & charMatch
        } else {
          rd[j] = (((rd[j + 1]! << 1) | 1) & charMatch) | (((lastRd[j + 1]! | lastRd[j]!) << 1) | 1) | lastRd[j + 1]!
        }
        if (rd[j]! & matchMask) != 0 {
          let score = bitapScoreForErrorCount(index, x:(j - 1), loc:loc, pattern:pattern, distance:distance)
          if score <= scoreThreshold {
            scoreThreshold = score
            bestLoc = j - 1
            if bestLoc > loc {
              start = maxOfConstAndDiff(1, b:2 * loc, c:bestLoc)
            } else {
              break
            }
          }
        }
        j = j - 1
      }
      if bitapScoreForErrorCount(index + 1, x:loc, loc:loc, pattern:pattern, distance:distance) > scoreThreshold {
        break
      }
      lastRd = rd
    }
    return bestLoc != NSNotFound ? bestLoc : nil
  }

  func matchAlphabet(_ pattern:String) -> [String: Int] {
    var alphabet = [String: Int]()
    for char in pattern {
      alphabet[String(char)] = 0
    }
    for (i, char) in pattern.enumerated() {
      let stringRepresentationOfCharacter = String(char)
      let possibleEntry = alphabet[stringRepresentationOfCharacter]!
      let value = possibleEntry | (1 << (pattern.count - i - 1))
      alphabet[stringRepresentationOfCharacter] = value
    }
    return alphabet
  }

  func bitapScoreForErrorCount(_ e:Int, x:Int, loc:Int, pattern:String, distance:Double) -> Double {
    let accuracy:Double = Double(e) / Double(pattern.count)
    let proximity = abs(loc - x)
    if distance == 0 {
      return Double(proximity == 0 ? accuracy : 1)
    } else {
      return Double(Double(accuracy) + (Double(proximity) / distance))
    }
  }

  func speedUpBySearchingForSubstring(_ pattern:String, loc:Int, threshold:Double, distance:Double) -> (bestLoc: Int, threshold: Double) {
    var scoreThreshold = threshold
    var bestLoc = NSNotFound
    var range: Range<String.Index> = startIndex..<index(startIndex, offsetBy: count)
    if let possibleLiteralSearchRange = self.range(of: pattern, options:NSString.CompareOptions.literal, range:range, locale: Locale.current) {
      bestLoc = self.distance(from: startIndex, to: possibleLiteralSearchRange.lowerBound)
      scoreThreshold = min(bitapScoreForErrorCount(0, x:bestLoc, loc:loc, pattern:pattern, distance:distance), threshold)
      range = startIndex..<index(startIndex, offsetBy: min(loc + pattern.count, count))
      if let possibleBackwardsSearchRange = self.range(of: pattern, options:NSString.CompareOptions.backwards, range:range, locale: Locale.current) {
        bestLoc = self.distance(from: startIndex, to: possibleBackwardsSearchRange.lowerBound)
        scoreThreshold = min(bitapScoreForErrorCount(0, x:bestLoc, loc:loc, pattern:pattern, distance:distance), scoreThreshold)
      }
    }
    return (bestLoc, threshold)
  }

  func generateOptions(_ options:FuzzyMatchOptions?) -> FuzzyMatchOptions {
    if let unwrappedOptions = options {
      return unwrappedOptions
    } else {
      return FuzzyMatchOptions.init()
    }
  }

  func maxOfConstAndDiff(_ a:Int, b:Int, c:Int) -> Int {
    return b <= c ? a : b - c + a
  }
}
