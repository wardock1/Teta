//
//  AddNewUserViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 29/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class AddNewUserViewController: UIViewController {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var secondNameTextField: UITextField!
	@IBOutlet weak var findUserButton: UIButton!
	@IBOutlet weak var inviteUserButton: UIButton!
	
	var userList = [User]() {
		didSet {
			print("userList in AddNewUser: \(userList)")
//			alertCommand(title: "", message: "User has been find and invite")
		}
	}
	var storageCurrentIdGroup: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setDecorationButtons()
	}
	
	func setDecorationButtons() {
		findUserButton.layer.cornerRadius = 17
		findUserButton.layer.masksToBounds = true
		findUserButton.layer.borderWidth = 1
		inviteUserButton.backgroundColor = .clear
		findUserButton.layer.borderColor = #colorLiteral(red: 0.255461961, green: 0.6874576807, blue: 0.7305728197, alpha: 1)
		
		inviteUserButton.layer.cornerRadius = 17
		inviteUserButton.layer.masksToBounds = true
		inviteUserButton.backgroundColor = .clear
		inviteUserButton.layer.borderWidth = 1
		inviteUserButton.layer.borderColor = #colorLiteral(red: 0.255461961, green: 0.6874576807, blue: 0.7305728197, alpha: 1)
	}
	
	@IBAction func findUserButtonTapped(_ sender: UIButton) {
		let searchUser = SearchUserNetworking()
		searchUser.searchUser(userName: nameTextField.text!) { (user) in
			self.userList.append(user)
		}
	}
	
	@IBAction func inviteUserButtonTapped(_ sender: UIButton) {
		let inviteUserToGroup = GroupInviteNetworking()
		var userId = ""
		for x in userList {
			userId = x.id!
		}
		
		if let groupId = storageCurrentIdGroup {
			inviteUserToGroup.inviteUser(groupId: groupId, receiverUserId: userId)
		}
		
	}
	
	
}
