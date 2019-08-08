//
//  GroupViewController.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UISearchBarDelegate, testProtocol {
	
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableVIew: UITableView!
    
    var groupListArray = [GroupList]()
	var searchingGroupList = [String]()
	var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.delegate = self
        tableVIew.dataSource = self
		searchBar.delegate = self
        tableVIew.allowsMultipleSelection = false
		gettingGroupList()
		
    }

	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text == nil || searchBar.text == "" {
			isSearching = false
			view.endEditing(true)
			tableVIew.reloadData()
		} else {
			isSearching = true
			let groupName = groupListArray.map { (value) -> String in
				return value.name
			}
			searchingGroupList = groupName.filter({$0.prefix(searchText.count) == searchText})
			tableVIew.reloadData()
		}
	}
	
	func gettingGroupList () {
		let groupNetworking = GroupNetworking()
		groupNetworking.getGroupList(userId: DataProvider.shared.userId) { (groupList) in
			self.groupListArray.append(groupList)
			
			DispatchQueue.main.async {
				self.tableVIew.reloadData()
			}
		}
		
		func getListOfEvents() {
			DataProvider.shared.completionForNewEvent = { (eventId) in
				print("getListOfEvent in grouPList eventID: \(eventId)")
				
			}
			
		}
		
		
	}
	
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromGroupToAddNewGroup" {
            let destinationVC = segue.destination as? AddNewGroupController
            destinationVC?.delegate = self
        }
        
        if segue.identifier == "fromGroupToDetailSegue" {
            let destinationVC = segue.destination as? DetailViewController

            if let currentIndex = tableVIew.indexPathForSelectedRow {

                let smg = groupListArray[currentIndex.row]
                destinationVC?.storageNameLabel = smg.name
                destinationVC?.storageDescrpLabel = smg.description
                destinationVC?.storageAvatarGroup = smg.avatar
				destinationVC?.storageIdGroup = smg.id
				destinationVC?.storageGroupDetail = [smg]
            }
        }
    }

    func transforData(data: GroupList) {
        groupListArray.append(data)
        tableVIew.reloadData()
    }

    }

extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if isSearching {
			return searchingGroupList.count
		} else {
			return groupListArray.count
		}
		
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell", for: indexPath) as? GroupListCell {
			
			if isSearching {
				cell.title.text = searchingGroupList[indexPath.row]
				
			} else {
//				cell.avatar.image = groupListArray[indexPath.row].avatar
				cell.descriptionLabel.text = groupListArray[indexPath.row].description
				cell.title.text = groupListArray[indexPath.row].name
//				cell.statusBar.image = groupListArray[indexPath.row].statusBar
				cell.nextButton.image = groupListArray[indexPath.row].nextButton
				
				if let some = cell.avatar {
					some.layer.cornerRadius = 0.5 * some.bounds.size.width
				}
				
			}
			return cell
			
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableVIew.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
