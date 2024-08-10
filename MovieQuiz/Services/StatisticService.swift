//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 21.07.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correctAnswers
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case gamesCount
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalQuestions = gamesCount * 10
        guard totalQuestions > 0 else {
            return 0.0
        }
        return (Double(correctAnswers) / Double(totalQuestions)) * 100.0
    }
    
    func store(correct count: Int, total amount: Int, date: Date) {
        correctAnswers += count
        gamesCount += 1
        
        let newGameResult = GameResult(correct: count, total: amount, date: date)
        if newGameResult.isBetterThan(bestGame) {
            bestGame = newGameResult
        }
    }
    
    func clearStatistics() {
        storage.removeObject(forKey: Keys.correctAnswers.rawValue)
        storage.removeObject(forKey: Keys.bestGameCorrect.rawValue)
        storage.removeObject(forKey: Keys.bestGameTotal.rawValue)
        storage.removeObject(forKey: Keys.bestGameDate.rawValue)
        storage.removeObject(forKey: Keys.gamesCount.rawValue)
        
        // Сбрасываем значения в памяти
        correctAnswers = 0
        gamesCount = 0
        bestGame = GameResult(correct: 0, total: 0, date: Date())
    }
}
