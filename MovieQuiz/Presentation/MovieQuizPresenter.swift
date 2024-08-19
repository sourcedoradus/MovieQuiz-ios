//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 19.08.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    // MARK: - Question presenter
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // MARK: - Action buttons logic
    
//    func yesButtonClicked(_ sender: UIButton) {
//        givenAnswer(answer: true)
//        setButtonsEnabled(false)
//    }
//    
//    func noButtonClicked(_ sender: UIButton) {
//        givenAnswer(answer: false)
//        setButtonsEnabled(false)
//    }
//    
//    func givenAnswer(answer: Bool) {
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        let isCorrect = (answer == currentQuestion.correctAnswer)
//        showAnswerResult(isCorrect: isCorrect)
//    }
    
    func givenAnswer(answer: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let isCorrect = (answer == currentQuestion.correctAnswer)
            viewController?.showAnswerResult(isCorrect: isCorrect)
        }
}
