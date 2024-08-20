import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        presenter.viewController = self
    //
    //        imageView.layer.cornerRadius = 20
    //    //    presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    //        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: presenter)
    //        alertPresenter = AlertPresenter(delegate: self)
    //        presenter.statisticService = StatisticService()
    //
    //    //    showLoadingIndicator()
    //        presenter.questionFactory?.loadData()
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
    }
    
    //    // MARK: - AlertPresenterDelegate
    //
    //    func presentAlert(alert: UIAlertController) {
    //        DispatchQueue.main.async { [weak self] in
    //            self?.present(alert, animated: true, completion: nil)
    //        }
    //    }
    
    // MARK: - Action buttons logic
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
     //   presenter.givenAnswer(answer: true)
        presenter.yesButtonClicked()
     //   setButtonsEnabled(false)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
    //    presenter.givenAnswer(answer: false)
        presenter.noButtonClicked()
    //    setButtonsEnabled(false)
    }
    
    func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    // MARK: - Functions
    
    //    func show(quiz step: QuizStepViewModel) {
    //        resetImageViewBorder()
    //        imageView.image = step.image
    //        textLabel.text = step.question
    //        counterLabel.text = step.questionNumber
    //    }
    //
    //    private func resetImageViewBorder() {
    //        imageView.layer.masksToBounds = true
    //        imageView.layer.borderWidth = 0
    //        imageView.layer.borderColor = UIColor.clear.cgColor
    //    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    //    func show(quiz result: QuizResultsViewModel) {
    //        resetImageViewBorder()
    //
    //        let alertModel = AlertModel(
    //            title: result.title,
    //            message: result.message,
    //            buttonText: result.buttonText,
    //            completion: { [weak self] in
    //                guard let self = self else { return }
    //
    //                presenter.resetQuestionIndex()
    //                presenter.correctAnswers = 0
    //                presenter.questionFactory?.requestNextQuestion()
    //            }
    //        )
    //
    //        alertPresenter?.showAlert(model: alertModel)
    //    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //    private func resetImageViewBorder() {
    //        imageView.layer.masksToBounds = true
    //        imageView.layer.borderWidth = 0
    //        imageView.layer.borderColor = UIColor.clear.cgColor
    //    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    //    func hideLoadingIndicator() {
    //        activityIndicator.isHidden = true
    //    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    //    func showNetworkError(message: String) {
    //        activityIndicator.isHidden = true
    //        activityIndicator.stopAnimating()
    //
    //        let alertModel = AlertModel(
    //            title: "Что-то пошло не так(",
    //            message: "Невозможно загрузить данные",
    //            buttonText: "Попробовать ещё раз",
    //            completion: { [weak self] in
    //                guard let self = self else { return }
    //
    //                presenter.questionFactory?.requestNextQuestion()
    //            }
    //        )
    //
    //        alertPresenter?.showAlert(model: alertModel)
    //    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать ещё раз",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
    }
    
    // MARK: - неразобранное
    
    //    func showAnswerResult(isCorrect: Bool) {
    //        if isCorrect {
    //            presenter.correctAnswers += 1
    //        }
    //
    //        imageView.layer.masksToBounds = true
    //        imageView.layer.borderWidth = 8
    //        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
    //            self?.presenter.showNextQuestionOrResults()
    //        }
    //    }
}
