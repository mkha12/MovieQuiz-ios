import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private var questionTitleLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showLoadingIndicator()
        noButton.titleLabel?.font =  UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font =  UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
        disableButtons()
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
        disableButtons()
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        enableButtons()
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertViewModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        } )
        
        let alert = AlertPresenter()
        alert.present(view: self, alert: alertViewModel, alertIdentifier: "myAlertID")
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
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
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
}
