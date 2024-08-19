import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
 //   private var currentQuestionIndex = 0
    private var correctAnswers = 0
  //  private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
  //  private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
    presenter.didReceiveNextQuestion(question: question)
//        guard let question = question else {
//            return
//        }
//        
//      //  currentQuestion = question
//        presenter.currentQuestion = question
//    //    let viewModel = convert(model: question)
//        let viewModel = presenter.convert(model: question)
//        
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegate
    
    func presentAlert(alert: UIAlertController) {
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.givenAnswer(answer: true)
        setButtonsEnabled(false)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.givenAnswer(answer: false)
        setButtonsEnabled(false)
    }
    
    // MARK: - Private functions
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
    
    func show(quiz step: QuizStepViewModel) {
        resetImageViewBorder()
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
//    private func givenAnswer(answer: Bool) {
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        let isCorrect = (answer == currentQuestion.correctAnswer)
//        showAnswerResult(isCorrect: isCorrect)
//    }
    
    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    private func showNextQuestionOrResults() {
      //  if currentQuestionIndex == questionsAmount - 1 {
            if presenter.isLastQuestion() {
          //  statisticService.store(correct: correctAnswers, total: questionsAmount, date: Date())
                statisticService.store(correct: correctAnswers, total: presenter.questionsAmount, date: Date())
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: viewModel)
        } else {
         //   currentQuestionIndex += 1
            presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
        setButtonsEnabled(true)
    }
    
    private func resetImageViewBorder() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        resetImageViewBorder()
        
        let gamesCount = statisticService.gamesCount
        let bestGame = statisticService.bestGame
        let totalAccuracy = statisticService.totalAccuracy
        let questionsAmount = presenter.questionsAmount
        
        let message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", totalAccuracy))%
        """
        
        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                
                //self.currentQuestionIndex = 0
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        )
        
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                
                self.questionFactory?.requestNextQuestion()
            }
        )
        
        alertPresenter?.showAlert(model: alertModel)
    }
}
