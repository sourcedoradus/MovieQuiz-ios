import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        activityIndicator.hidesWhenStopped = true
        setButtonsEnabled(isEnabled: false)
        
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - Action buttons
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Functions
    
    func setButtonsEnabled(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            self?.presenter.restartGame()
        }
        
        alert.addAction(action)
        presentAlert(alert)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать ещё раз",
                                   style: .default) { [weak self] _ in
            self?.presenter.reloadData()
        }
        
        alert.addAction(action)
        presentAlert(alert)
    }
    
    private func presentAlert(_ alert: UIAlertController) {
        if presentedViewController != nil {
            presentedViewController.dismiss(animated: false) { [weak self] in
                self?.present(alert, animated: true)
            }
        } else {
            present(alert, animated: true)
        }
    }
}
