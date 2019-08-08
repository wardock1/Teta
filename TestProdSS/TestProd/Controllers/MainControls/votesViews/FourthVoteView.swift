//
//  FourthVoteView.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class FourthVoteView: UIViewController {
	
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var firstButton: UIButton!
	@IBOutlet weak var secondButton: UIButton!
	@IBOutlet weak var thirdButton: UIButton!
	@IBOutlet weak var fourthButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var nextQuestionButton: UIButton!
	
	var questions: [Question]!
	var currentQuestion = 0
	
	var loyalty = 0
	var storageEventId: String? {
		didSet {
			print("fourthVoteView: \(String(describing: storageEventId))")
		}
	}
	var subjectUserId: String?
	
	var answerValueArray = [Int]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		saveButton.isHidden = true
		loadQuestion()
		showQuestion(0)
	}
	
	var first: Int?
	var second: Int?
	var third: Int?
	var fourth: Int?
	
	@IBAction func firstButtonTapped(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			first = 0
		} else {
			first = nil
		}
	}
	@IBAction func secondButtonTapped(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			second = 1
		} else {
			second = nil
		}
	}
	@IBAction func thirdButtonTapped(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			third = 2
		} else {
			third = nil
		}
	}
	@IBAction func fourthButtonTapped(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
	}
	
	@IBAction func saveButtonTapped(_ sender: UIButton) {
		if let eventID = storageEventId, let prof = DataProvider.shared.professionalism, let loyalty = DataProvider.shared.loyalty, let efficiency = DataProvider.shared.efficiency, let discipline = DataProvider.shared.discipline, let subjectUserId = subjectUserId {
			let responseRatin = ResponseRating()
			responseRatin.responsingAnswersToServer(eventID: eventID, subjectId: subjectUserId, professionalism: prof, loyalty: loyalty, efficiency: efficiency, discipline: discipline)
		}
		if let tabBarView = storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? TabBarController {
			present(tabBarView, animated: true, completion: nil)
		}
	}
	
	@IBAction func nextQuestionTapped(_ sender: UIButton) {
		multiplayAnswers(first: first, second: second, third: third, fourth: fourth)
		nextQuestion()
	}
	
	func loadQuestion() -> Void {
		let question1 = Question(
			question: "",
			answers: [
				Answer(answer: "Проявляет инициативность", returnValue: 3),
				Answer(answer: "Поддерживает инициативу коллег", returnValue: 2),
				Answer(answer: "Хорошо знает компанию", returnValue: 1)
			]
		)
		
		let question2 = Question(
			question: "",
			answers: [
				Answer(answer: "Ставит интересы компании выше собственных", returnValue: 2),
				Answer(answer: "Гордится своей работой", returnValue: 2),
				Answer(answer: "Критикует компанию на публике", returnValue: 0)
			]
		)
		
		let question3 = Question(
			question: "",
			answers: [
				Answer(answer: "Негативно реагирует на просьбы коллег", returnValue: 0),
				Answer(answer: "Проявляет агрессию в общении", returnValue: 0),
				Answer(answer: "Портит позитивную рабочую обстановку", returnValue: 0),
				Answer(answer: "Преследует личные / корыстные цели", returnValue: 0)
			]
		)
		
		self.questions = [question1, question2, question3]
	}
	
	func showQuestion(_ questionId : Int) -> Void {
		
		let selectedQuestion : Question = questions[questionId]
		
		firstButton.setTitle(selectedQuestion.answers[0].response, for: .normal)
		secondButton.setTitle(selectedQuestion.answers[1].response, for: .normal)
		thirdButton.setTitle(selectedQuestion.answers[2].response, for: .normal)
		var count = 0
		for _ in selectedQuestion.answers {
			count += 1
		}
		if count > 3 {
			fourthButton.setTitle(selectedQuestion.answers[3].response, for: .normal)
		} else {
			fourthButton.isHidden = true
		}
	}
	
	func multiplayAnswers(first: Int?, second: Int?, third: Int?, fourth: Int?) {
		if let first = first {
			let answer : Answer = questions[currentQuestion].answers[first]
			loyalty += answer.returnValue
		}
		if let second = second {
			let answer : Answer = questions[currentQuestion].answers[second]
			loyalty += answer.returnValue
		}
		if let third = third {
			let answer : Answer = questions[currentQuestion].answers[third]
			loyalty += answer.returnValue
		}
		if let fourth = fourth {
			let answer : Answer = questions[currentQuestion].answers[fourth]
			loyalty += answer.returnValue
		}
		print("currentValueLoalty: \(loyalty)")
	}
	
	func nextQuestion() {
		currentQuestion += 1
		
		if (currentQuestion < questions.count) {
			showQuestion(currentQuestion)
			firstButton.isSelected = false
			secondButton.isSelected = false
			thirdButton.isSelected = false
			fourthButton.isSelected = false
		} else {
			endQuiz()
		}
	}
	
	func disableButtons() {
		firstButton.isHidden = true
		secondButton.isHidden = true
		thirdButton.isHidden = true
		fourthButton.isHidden = true
	}
	
	func endQuiz() {
		print("game is ended, gradeValue: \(loyalty)")
		DataProvider.shared.loyalty = loyalty
		saveButton.setTitle("Завершнить опрос", for: .normal)
		questionLabel.text = "Благодарим за Ваш отзыв"
		disableButtons()
		nextQuestionButton.isHidden = true
		saveButton.isHidden = false
		
	}
	
}
