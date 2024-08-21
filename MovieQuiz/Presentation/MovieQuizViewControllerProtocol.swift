//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 20.08.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func setButtonsEnabled(isEnabled: Bool)
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
