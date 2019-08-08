//
//  DetailViewController.swift
//  TestProd
//
//  Created by Developer on 15/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	
	@IBOutlet weak var imageGroup: UIImageView!
	@IBOutlet weak var groupName: UILabel!
	@IBOutlet weak var groupDescription: UITextView!
	@IBOutlet weak var allUsersButton: UIButton!
	@IBOutlet weak var allEventsButton: UIButton!
	@IBOutlet weak var tableViewController: UITableView!
	@IBOutlet weak var newEventButton: UIButton!
	
	var storageNameLabel: String?
	var storageDescrpLabel: String?
	var storageAvatarGroup: UIImage?
	var storageIdGroup: String?
	var storageGroupDetail: [GroupList]?
	var storageEventID: String?
	let eventsNetwroking = EventsInGroupNetworking()
	
	var someArray = [GroupList]()
	var groupDetail = [GroupList]()
	var currentEventList = [Event]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setDecorationButtons()
		imageGroup.layer.cornerRadius = 0.5 * imageGroup.bounds.size.width
		tableViewController.delegate = self
		tableViewController.dataSource = self
		getInfoAboutEvent()
		getCurrentEvents()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		imageGroup.image = storageAvatarGroup
		groupName.text = storageNameLabel
		groupDescription.text = storageDescrpLabel
		groupDetail = storageGroupDetail!
//		getCurrentEvents()
	}
	
	func setDecorationButtons() {
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		allUsersButton.layer.cornerRadius = 17
		allUsersButton.layer.masksToBounds = true
		allUsersButton.backgroundColor = .clear
		allUsersButton.layer.setGradienBorder(colors: bor, width: 1)
		
		allEventsButton.layer.cornerRadius = 17
		allEventsButton.layer.masksToBounds = true
		allEventsButton.backgroundColor = .clear
		allEventsButton.layer.setGradienBorder(colors: bor, width: 1)
		
		newEventButton.layer.cornerRadius = 17
	}
	
	
	func getCurrentEvents() {
		if let groupId = storageIdGroup {
			eventsNetwroking.getEventsInGroup(groupID: groupId) { (event) in
				print("getCurrenEvent work: \(event)")
			}
		}
		
		
	}
	
	func getInfoAboutEvent() {
		DataProvider.shared.completionForSingleEvent = { (value) in
			print("getInfoAboutEvent works: \(value)")
			self.currentEventList.append(value)
			self.storageEventID = value.id
			DispatchQueue.main.async {
				self.tableViewController.reloadData()
			}
			
//			let delete = ResponseRating()
//			delete.searchUnansweredUsers(eventId: value.id ?? "")			
//			DataProvider.shared.completionDeletingEvent = { (value) in
//				print("value delete is: \(value)")
//				self.currentEventList.removeAll()
//				DispatchQueue.main.async {
//					self.tableViewController.reloadData()
//				}
//			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "fromGroupToMembers" {
			let destinationVC = segue.destination as? MembersControllerView
			var groupId = ""
			for element in groupDetail {
				groupId = element.id ?? ""
			}
			destinationVC?.storageIdGroup = groupId
//			destinationVC?.gettingMembersInGroup(for: groupId)
			
		}
	}
	@IBAction func createNewEventButtonTapped(_ sender: UIButton) {
		if let newEventView = storyboard?.instantiateViewController(withIdentifier: "newEventView") as? NewEventMainController {
			newEventView.storageGroupId = storageIdGroup
			navigationController?.pushViewController(newEventView, animated: true)
		}
	}
}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currentEventList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "groupDetailCellId", for: indexPath) as? DetailTableViewCell {
			
			if let _ = currentEventList[indexPath.row].id {
				cell.textLabel?.text = "Новое событие"
			}
			
			return cell
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let voteView = storyboard?.instantiateViewController(withIdentifier: "voteView") as? VoteViewController {
			if let eventId = currentEventList[indexPath.row].id {
				let searchUnansweredUser = ResponseRating()
				searchUnansweredUser.searchUnansweredUsers(eventId: eventId)
			}
			print("currentEventList ID indexpath: \(String(describing: currentEventList[indexPath.row].id))")
			voteView.eventId = currentEventList[indexPath.row].id
			present(voteView, animated: true, completion: nil)
		}
	}
	
	
	
	
	
}
