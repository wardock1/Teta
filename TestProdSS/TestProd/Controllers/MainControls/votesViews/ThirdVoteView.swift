//
//  ThirdVoteView.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class ThirdVoteView: UIViewController {
	
	@IBOutlet weak var firstSlider: UISlider!
	@IBOutlet weak var secondSlider: UISlider!
	@IBOutlet weak var thirdSlider: UISlider!
	@IBOutlet weak var fourthSlider: UISlider!
	@IBOutlet weak var saveButton: UIButton!
	
	
	@IBOutlet weak var labelFirtSlider: UILabel!
	@IBOutlet weak var labelSecondSlider: UILabel!
	@IBOutlet weak var labelThirdSlider: UILabel!
	@IBOutlet weak var labelFourthSlider: UILabel!
	
	var efficiency = 0
	var storageEventId: String? {
		didSet {
			print("thirdVoteView eventID: \(String(describing: storageEventId))")
		}
	}
	var subjectUserId: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	var firstValueSlider = 0
	var secondValueSlider = 0
	var thirdValueSlider = 0
	var fourthValueSlider = 0
	
	@IBAction func firstSliderTapped(_ sender: UISlider) {		
		sender.setValue(sender.value.rounded(.down), animated: true)
		labelFirtSlider.text = "Текущее значение: \(Int(sender.value))"
		let value = sender.value
		firstValueSlider = Int(value)
	}
	@IBAction func secondSliderTapped(_ sender: UISlider) {
		sender.setValue(sender.value.rounded(.down), animated: true)
		labelSecondSlider.text = "Текущее значение: \(Int(sender.value))"
		let value = sender.value
		secondValueSlider = Int(value)
	}
	@IBAction func thirdSliderTapped(_ sender: UISlider) {
		sender.setValue(sender.value.rounded(.down), animated: true)
		labelThirdSlider.text = "Текущее значение: \(Int(sender.value))"
		let value = sender.value
		thirdValueSlider = Int(value)
	}
	@IBAction func fourthSliderTapped(_ sender: UISlider) {
		sender.setValue(sender.value.rounded(.down), animated: true)
		labelFourthSlider.text = "Текущее значение: \(Int(sender.value))"
		let value = sender.value
		fourthValueSlider = Int(value)
	}
	
	@IBAction func saveButtonTapped(_ sender: UIButton) {
		calculateDecision(firstSlide: firstValueSlider, secondSlider: secondValueSlider, thirdSlider: thirdValueSlider, fourthSlider: fourthValueSlider)
		if let fourthVoteView = storyboard?.instantiateViewController(withIdentifier: "FourthVoteView") as? FourthVoteView {
			fourthVoteView.storageEventId = storageEventId
			fourthVoteView.subjectUserId = subjectUserId
			print("game is ended, gradeValue: \(efficiency)")
			DataProvider.shared.efficiency = efficiency
			present(fourthVoteView, animated: true, completion: nil)
		}
	}
	
	func calculateDecision(firstSlide: Int, secondSlider: Int, thirdSlider: Int, fourthSlider: Int) {
		let decidion = firstSlide + secondSlider + thirdSlider + fourthSlider
		efficiency = decidion
	}
	
	
}
