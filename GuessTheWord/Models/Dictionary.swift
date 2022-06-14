/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class Dictionary: ObservableObject {
  var wordLength: Int
  @Published var words: [String] = []
  @Published var commonWords: [String] = []

  init(length: Int) {
    wordLength = length

    guard
      let fileUrl = Bundle.main.url(forResource: "words-5", withExtension: "txt"),
      let dictionary = try? String(contentsOf: fileUrl, encoding: .utf8) else {
        return
      }

    for word in dictionary.split(separator: "\n") {
      let newWord = String(word)
      if newWord.count == wordLength {
        words.append(newWord.uppercased())
      }
    }

    guard
      let commonFileUrl = Bundle.main.url(forResource: "common-words-5", withExtension: "txt"),
      let commonDictionary = try? String(contentsOf: commonFileUrl, encoding: .utf8) else {
        return
      }

    for word in commonDictionary.split(separator: "\n") {
      let newWord = String(word)
      if newWord.count == wordLength {
        commonWords.append(newWord.uppercased())
      }
    }
  }

  func isValidWord(_ word: String) -> Bool {
    let casedWord = word.uppercased()
    return words.contains { $0 == casedWord }
  }
}
