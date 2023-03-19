import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer(data: [MostPopularMovie])
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
