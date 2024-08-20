//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 19.08.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewController?
    
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    //    func didReceiveNextQuestion(question: QuizQuestion?) {
    //        presenter.didReceiveNextQuestion(question: question)
    //    }
    
    //    init(viewController: MovieQuizViewController) {
    //            self.viewController = viewController
    //
    //            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    //            questionFactory?.loadData()
    //       //     viewController.showLoadingIndicator()
    //        }
    
    //    func didReceiveNextQuestion(question: QuizQuestion?) {
    //        guard let question = question else {
    //            return
    //        }
    //
    //        currentQuestion = question
    //        let viewModel = convert(model: question)
    //
    //        DispatchQueue.main.async { [weak self] in
    //            self?.viewController?.show(quiz: viewModel)
    //        }
    //    }
    //
    //    func didLoadDataFromServer() {
    //        //   activityIndicator.isHidden = true
    //        viewController?.hideLoadingIndicator()
    //        questionFactory?.requestNextQuestion()
    //    }
    //
    //    func didFailToLoadData(with error: Error) {
    //        viewController?.showNetworkError(message: error.localizedDescription)
    //    }
    
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Functions
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    //    func givenAnswer(answer: Bool) {
    //        guard let currentQuestion = currentQuestion else {
    //            return
    //        }
    //        let isCorrect = (answer == currentQuestion.correctAnswer)
    //        viewController?.showAnswerResult(isCorrect: isCorrect)
    //    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    //    func convert(model: QuizQuestion) -> QuizStepViewModel {
    //        return QuizStepViewModel(
    //            image: UIImage(data: model.image) ?? UIImage(),
    //            question: model.text,
    //            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    //    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // этот метод странно дублирует другой выше с таким же названием
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = correctAnswers == self.questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func makeResultsMessage() -> String {
     //   statisticService.store(correct: correctAnswers, total: questionsAmount)
        statisticService.store(correct: correctAnswers, total: questionsAmount, date: Date())
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        //            Ваш результат: \(correctAnswers)/\(questionsAmount)

        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    // MARK: - неразобранное
    
    //    func resetQuestionIndex() {
    //        currentQuestionIndex = 0
    //    }
    
    //    func showNextQuestionOrResults() {
    //        if isLastQuestion() {
    //            statisticService.store(correct: correctAnswers, total: questionsAmount, date: Date())
    //            
    //            let gamesCount = statisticService.gamesCount
    //            let bestGame = statisticService.bestGame
    //            let totalAccuracy = statisticService.totalAccuracy
    //            let questionsAmount = questionsAmount
    //            
    //            let message = """
    //            Ваш результат: \(correctAnswers)/\(questionsAmount)
    //            Количество сыгранных квизов: \(gamesCount)
    //            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
    //            Средняя точность: \(String(format: "%.2f", totalAccuracy))%
    //            """
    //            
    //            let viewModel = QuizResultsViewModel(
    //                title: "Этот раунд окончен!",
    //                message: message,
    //                buttonText: "Сыграть ещё раз"
    //            )
    //            
    //            viewController?.show(quiz: viewModel)
    //            
    //        } else {
    //            switchToNextQuestion()
    //            self.questionFactory?.requestNextQuestion()
    //        }
    //        viewController?.setButtonsEnabled(true)
    //    }
    
    
}
