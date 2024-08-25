//
//  ConvertTest.swift
//  MovieQuizTests
//
//  Created by Valentin Medvedev on 20.08.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
    private(set) var showQuizStepCalled = false
    private(set) var showQuizStepViewModel: QuizStepViewModel?
    
    private(set) var showQuizResultCalled = false
    private(set) var showQuizResultViewModel: QuizResultsViewModel?
    
    private(set) var isSetButtonsEnabledCalled = false
    private(set) var setButtonsEnabledParameter: Bool?
    
    private(set) var highlightImageBorderCalled = false
    private(set) var isCorrectAnswerHighlighted: Bool?
    
    private(set) var showLoadingIndicatorCalled = false
    private(set) var hideLoadingIndicatorCalled = false
    
    private(set) var showNetworkErrorCalled = false
    private(set) var networkErrorMessage: String?
    
    func show(quiz step: QuizStepViewModel) {
        showQuizStepCalled = true
        showQuizStepViewModel = step
    }
    
    func show(quiz result: QuizResultsViewModel) {
        showQuizResultCalled = true
        showQuizResultViewModel = result
    }
    
    func setButtonsEnabled(isEnabled: Bool) {
        isSetButtonsEnabledCalled = true
        setButtonsEnabledParameter = isEnabled
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        highlightImageBorderCalled = true
        isCorrectAnswerHighlighted = isCorrectAnswer
    }
    
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func showNetworkError(message: String) {
        showNetworkErrorCalled = true
        networkErrorMessage = message
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
