//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 20.07.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
