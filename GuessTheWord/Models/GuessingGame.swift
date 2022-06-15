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
import SwiftUI

enum GameState {
  case initializing
  case new
  case inprogress
  case won
  case lost
}

class GuessingGame: ObservableObject {
  let wordLength = 5
  let maxGuess = 6
  var dictionary: Dictionary
  var status: GameState = .initializing
  @Published var targetWord: String
  @Published var currentGuess = 0
  @Published var guesses: [Guess]
  
  init() {
    dictionary = Dictionary(length: wordLength)
    let totalWords = dictionary.commonWords.count
    let randomWord = Int.random(in: 0..<totalWords)
    let word = dictionary.commonWords[randomWord]
    targetWord = word
    #if DEBUG
    print("selected word: \(word)")
    #endif
    guesses = .init()
    guesses.append(Guess())
    status = .new
  }
  
  func addKey(letter: String) {
    if status == .new {
      status = .inprogress
    }
    guard status == .inprogress else {
      return
    }
    
    switch letter {
    case "<":
      deleteLetter()
    default:
      if guesses[currentGuess].word.count < wordLength {
        let newLetter = GuessedLetter(letter: letter)
        guesses[currentGuess].word.append(newLetter)
      }
    }
  }
  
  func deleteLetter() {
    let currentLetters = guesses[currentGuess].word.count
    guard currentLetters > 0 else { return }
    guesses[currentGuess].word.remove(at: currentLetters - 1)
  }
  
  func checkGuess() {
    guard guesses[currentGuess].word.count == wordLength else { return }
    
    if !dictionary.isValidWord(guesses[currentGuess].letters) {
      guesses[currentGuess].status = .invalidWord
      return
    }
    
    guesses[currentGuess].status = .complete
    var targetLettersRemaining = Array(targetWord)
    for index in guesses[currentGuess].word.indices {
      let stringIndex = targetWord.index(targetWord.startIndex, offsetBy: index)
      let letterAtIndex = String(targetWord[stringIndex])
      if letterAtIndex == guesses[currentGuess].word[index].letter {
        guesses[currentGuess].word[index].status = .inPosition
        if let letterIndex =
            targetLettersRemaining.firstIndex(of: Character(letterAtIndex)) {
          targetLettersRemaining.remove(at: letterIndex)
        }
      }
    }
  }
}

// extension GuessingGame {
//  convenience init(word: String) {
//    self.init()
//    self.targetWord = word
//  }
//
//  static func inProgressGame() -> GuessingGame {
//    let game = GuessingGame(word: "SMILE")
//    game.addKey(letter: "S")
//    game.addKey(letter: "T")
//    game.addKey(letter: "O")
//    game.addKey(letter: "L")
//    game.addKey(letter: "E")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "M")
//    game.addKey(letter: "I")
//    game.addKey(letter: "L")
//    game.addKey(letter: "E")
//    game.addKey(letter: "S")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "S")
//    return game
//  }
//
//  static func wonGame() -> GuessingGame {
//    let game = GuessingGame(word: "SMILE")
//    game.addKey(letter: "S")
//    game.addKey(letter: "T")
//    game.addKey(letter: "O")
//    game.addKey(letter: "L")
//    game.addKey(letter: "E")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "M")
//    game.addKey(letter: "I")
//    game.addKey(letter: "L")
//    game.addKey(letter: "E")
//    game.addKey(letter: "S")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "S")
//    game.addKey(letter: "M")
//    game.addKey(letter: "I")
//    game.addKey(letter: "L")
//    game.addKey(letter: "E")
//    game.addKey(letter: ">")
//
//    return game
//  }
//
//  static func lostGame() -> GuessingGame {
//    let game = GuessingGame(word: "SMILE")
//
//    game.addKey(letter: "P")
//    game.addKey(letter: "I")
//    game.addKey(letter: "A")
//    game.addKey(letter: "N")
//    game.addKey(letter: "O")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "S")
//    game.addKey(letter: "T")
//    game.addKey(letter: "O")
//    game.addKey(letter: "L")
//    game.addKey(letter: "E")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "S")
//    game.addKey(letter: "P")
//    game.addKey(letter: "O")
//    game.addKey(letter: "I")
//    game.addKey(letter: "L")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "S")
//    game.addKey(letter: "T")
//    game.addKey(letter: "A")
//    game.addKey(letter: "R")
//    game.addKey(letter: "E")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "M")
//    game.addKey(letter: "I")
//    game.addKey(letter: "L")
//    game.addKey(letter: "E")
//    game.addKey(letter: "S")
//    game.addKey(letter: ">")
//
//    game.addKey(letter: "S")
//    game.addKey(letter: "M")
//    game.addKey(letter: "E")
//    game.addKey(letter: "L")
//    game.addKey(letter: "L")
//    game.addKey(letter: ">")
//
//    return game
//  }
//
// static func complexGame() -> GuessingGame {
//   let game = GuessingGame(word: "THEME")
//
//   game.addKey(letter: "E")
//   game.addKey(letter: "E")
//   game.addKey(letter: "R")
//   game.addKey(letter: "I")
//   game.addKey(letter: "E")
//   game.addKey(letter: ">")
//
//   game.addKey(letter: "S")
//   game.addKey(letter: "T")
//   game.addKey(letter: "E")
//   game.addKey(letter: "E")
//   game.addKey(letter: "L")
//   game.addKey(letter: ">")
//
//   game.addKey(letter: "T")
//   game.addKey(letter: "H")
//   game.addKey(letter: "E")
//   game.addKey(letter: "M")
//   game.addKey(letter: "E")
//   game.addKey(letter: ">")
//
//   return game
//  }
// }
