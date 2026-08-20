//
//  StatisticServiceTests.swift
//  MovieQuizTests
//
//  Created by Valentin Medvedev on 20.08.2026.
//

import XCTest
@testable import MovieQuiz

final class StatisticServiceTests: XCTestCase {
    private var sut: StatisticService!
    private var storage: UserDefaults!
    private let suiteName = "StatisticServiceTests"
    
    override func setUp() {
        super.setUp()
        storage = UserDefaults(suiteName: suiteName)
        storage.removePersistentDomain(forName: suiteName)
        sut = StatisticService(storage: storage)
    }
    
    override func tearDown() {
        storage.removePersistentDomain(forName: suiteName)
        sut = nil
        storage = nil
        super.tearDown()
    }
    
    func testFirstGameBecomesRecordEvenWithZeroCorrect() {
        let date = Date(timeIntervalSince1970: 1_000)
        
        sut.store(correct: 0, total: 10, date: date)
        
        XCTAssertEqual(sut.gamesCount, 1)
        XCTAssertEqual(sut.bestGame.correct, 0)
        XCTAssertEqual(sut.bestGame.total, 10)
        XCTAssertEqual(sut.bestGame.date, date)
    }
    
    func testBetterGameUpdatesRecord() {
        let firstDate = Date(timeIntervalSince1970: 1_000)
        let secondDate = Date(timeIntervalSince1970: 2_000)
        
        sut.store(correct: 5, total: 10, date: firstDate)
        sut.store(correct: 8, total: 10, date: secondDate)
        
        XCTAssertEqual(sut.bestGame.correct, 8)
        XCTAssertEqual(sut.bestGame.date, secondDate)
        XCTAssertEqual(sut.gamesCount, 2)
    }
    
    func testWorseGameDoesNotUpdateRecord() {
        let firstDate = Date(timeIntervalSince1970: 1_000)
        
        sut.store(correct: 8, total: 10, date: firstDate)
        sut.store(correct: 3, total: 10, date: Date())
        
        XCTAssertEqual(sut.bestGame.correct, 8)
        XCTAssertEqual(sut.bestGame.date, firstDate)
    }
    
    func testEqualScoreDoesNotOverwriteRecordDate() {
        let firstDate = Date(timeIntervalSince1970: 1_000)
        
        sut.store(correct: 7, total: 10, date: firstDate)
        sut.store(correct: 7, total: 10, date: Date())
        
        XCTAssertEqual(sut.bestGame.correct, 7)
        XCTAssertEqual(sut.bestGame.date, firstDate)
    }
    
    func testTotalAccuracy() {
        sut.store(correct: 5, total: 10, date: Date())
        sut.store(correct: 7, total: 10, date: Date())
        
        XCTAssertEqual(sut.totalAccuracy, 60.0, accuracy: 0.01)
    }
}
