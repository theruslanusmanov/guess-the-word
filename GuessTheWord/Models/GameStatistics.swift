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

struct GameStatistics {
  var gameRecord: String

  var gamesPlayed: Int {
    gameRecord.count
  }

  var gamesWon: Int {
    gameRecord.filter { $0 != "L" }.count
  }

  var percentageWon: Int {
    guard gamesPlayed > 0 else { return 0 }
    return Int((Double(gamesWon) / Double(gamesPlayed) * 100.0).rounded())
  }

  var currentWinStreak: Int {
    return gameRecord.reversed().firstIndex(of: "L") ?? gameRecord.count
  }

  var maxWinStreak: Int {
    let games = Array(gameRecord) // gameRecord.map { $0 }
    var maxStreak = 0
    var currentStreak = 0
    for game in games {
      if game != "L" {
        currentStreak += 1
      } else {
        maxStreak = currentStreak
        currentStreak = 0
      }
    }
    if currentStreak > maxStreak {
      maxStreak = currentStreak
    }

    return maxStreak
  }

  var winRound: [Int] {
    let win1 = gameRecord.filter { $0 == "1" }.count
    let win2 = gameRecord.filter { $0 == "2" }.count
    let win3 = gameRecord.filter { $0 == "3" }.count
    let win4 = gameRecord.filter { $0 == "4" }.count
    let win5 = gameRecord.filter { $0 == "5" }.count
    let win6 = gameRecord.filter { $0 == "6" }.count

    return [win1, win2, win3, win4, win5, win6]
  }
}
