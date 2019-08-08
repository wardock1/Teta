//
//  MembersControllerView.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 22/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class MembersControllerView: UIViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	var storageIdGroup: String?
	var storageEventID: String?
	
	var memberList = [User]() {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegating()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
		gettingMembersInGroup(for: storageIdGroup!)
		tableView.separatorStyle = .none
	}
	
	func delegating () {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	
	@objc func addTapped () {
		if let segue = storyboard?.instantiateViewController(withIdentifier: "addUserStoryId") as? AddNewUserViewController {
			segue.storageCurrentIdGroup = storageIdGroup
			navigationController?.pushViewController(segue, animated: true)
		}
	}
	
	func gettingMembersInGroup(for groupId: String) {
		let membersInGroupNetworking = MembersInGroupNetworking()
		membersInGroupNetworking.getMembersInGroup(groupId: storageIdGroup ?? "") { (currentUsers) in
			print("memebers: \(currentUsers)")
			self.memberList = currentUsers
		}
		
	}
	
}

extension MembersControllerView: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memberList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "memberViewCellId", for: indexPath) as? MembersCell {
			
			cell.nameLabel.text = memberList[indexPath.row].name
			return cell
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	
}
