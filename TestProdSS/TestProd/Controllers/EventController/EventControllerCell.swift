//
//  EventControllerCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 01/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol InvitationDeclinedbly {
	func declineInvition (for index: Int, invitationData: Invitations)
	func confirmInvition (for index: Int, invitationData: Invitations)
}

class EventControllerCell: UITableViewCell {
	
	@IBOutlet weak var nameUserFromInvitation: UILabel!
	@IBOutlet weak var nameUserToInvition: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var deniedButton: UIButton!
	
	var declineDelegate: InvitationDeclinedbly?
	
	var currentIndex: Int!
	var currentInvitation: Invitations!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setDecorationButtons()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
		bounds = bounds.inset(by: padding)
	}
	
	func setDecorationButtons() {
		confirmButton.layer.cornerRadius = 17
		confirmButton.layer.masksToBounds = true
		confirmButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		deniedButton.layer.cornerRadius = 17
		deniedButton.layer.masksToBounds = true
		deniedButton.backgroundColor = .clear
		deniedButton.setTitleColor(#colorLiteral(red: 0.257500715, green: 0.7256385985, blue: 0.9175810239, alpha: 1), for: .normal)
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		deniedButton.layer.setGradienBorder(colors: bor, width: 5)
		
	}
	
	func currentInvitationAndIndexPath(at index: Int, dataInvitation: Invitations) {
		currentIndex = index
		currentInvitation = dataInvitation
	}
	
	@IBAction func confirmTapped(_ sender: UIButton) {
		declineDelegate?.confirmInvition(for: currentIndex, invitationData: currentInvitation)
	}
	
	@IBAction func deniedTapped(_ sender: UIButton) {
		declineDelegate?.declineInvition(for: currentIndex, invitationData: currentInvitation)
	}
	
}
