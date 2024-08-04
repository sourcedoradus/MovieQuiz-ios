//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 20.07.2024.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func presentAlert(alert: UIAlertController)
}
