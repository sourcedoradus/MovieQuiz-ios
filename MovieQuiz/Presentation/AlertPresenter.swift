//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 20.07.2024.
//

import Foundation
import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        delegate?.presentAlert(alert: alert)
    }
}
