//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 20.07.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
