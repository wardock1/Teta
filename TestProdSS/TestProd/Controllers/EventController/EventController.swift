//
//  EventController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 01/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Starscream

class EventController: UIViewController {
	
	
	@IBOutlet weak var tableView: UITableView!
	
	var arrList = [Invitations]()
	var userList = [User]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
		self.tableView.allowsSelection = false
		getCurrentEvent()
		fetchInfoAboutInvitations()
	}
	
	func fetchInfoAboutInvitations() {
		DataProvider.shared.completionHandler = { (invitation) in
			self.arrList.append(invitation)
			
//			let getInfoUser = SearchUserNetworking()
//			if let userId = invitation.initiator {
//				getInfoUser.getUserInfo(userId: userId, completion: { (user) in
//					print("fetchInfoAboutIng gettin userinfo: \(user)")
//					self.userList.append(user)
//					DispatchQueue.main.async {
//						self.tableView.reloadData()
//					}
//				})
//			}
			
		}
	}
	
	
	func getCurrentEvent() {
		let currentInvitations = CurrentInvitationsNetwork()
		currentInvitations.getCurrentInvitations { (currentInvitations) in
			self.arrList.append(currentInvitations)
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
			
			let getInfoUser = SearchUserNetworking()
			if let userId = currentInvitations.initiator {
				getInfoUser.getUserInfo(userId: userId, completion: { (user) in
					print("fetchInfoAboutIng gettin userinfo: \(user)")
					self.userList.append(user)
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				})
			}
		}
	}
	
//	func fetchInfoAboutInvitations(text: String) {
//		let info = InfoAboutInvitation()
//		info.getInfoAboutInvitationAfterSocket(invitationId: text) {(invitation) in
//			print("some inv: \(invitation)")
//			DataProvider.shared.someArry.append(invitation)
//		}
//	}
}

extension EventController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "EventControllerCell", for: indexPath) as? EventControllerCell {
			let invitationData = arrList[indexPath.row]
			let currentRow = indexPath.row
			var initiator = ""
			
			for x in userList {
				initiator = x.name ?? "Null"
			}
			
			cell.nameUserFromInvitation.text = initiator
			
			cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
			cell.currentInvitationAndIndexPath(at: currentRow, dataInvitation: invitationData)
			cell.declineDelegate = self
			
			
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 170
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}

extension EventController: InvitationDeclinedbly {
	
	func confirmInvition(for index: Int, invitationData: Invitations) {
		let invitationResponse = InvitationResponse()
		if let invitationId = invitationData.id {
			invitationResponse.confirmToInvite(userId: invitationId) { (response) in
				self.arrList.remove(at: index)
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
	}
	
	func declineInvition(for index: Int, invitationData: Invitations) {
		print("some DDDS index: \(index)")
		let invitationResponse = InvitationResponse()
		if let invitationId = invitationData.id {
			invitationResponse.deniedToInvite(userId: invitationId) { (response) in
				self.arrList.remove(at: index)
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
	}
	
}
