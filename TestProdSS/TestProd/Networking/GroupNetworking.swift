//
//  GroupNetworking.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 18/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Firebase

class GroupNetworking {
	
	func creatingNewGroup (name: String, description: String) {
		
		let url = URL(string: "http://89.189.159.160:80/api/group")!
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let parameters: [String: Any] = [
			"descriptive": [
				"title": name,
				"description": description
			]
		]
		
		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				self.handleError(error!)
				print("error: \(String(describing: error))")
			}
			
			let data = data
			// GGs - Ggs = "id = 5d3ee587b43fdd00018c4b8c"
			//DDgs - 5d3ee5b3b43fdd00018c4b8e
			// userID - 5d3ecd09b43fdd0001443bcd
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
				print(jsonResponse)
				guard let getData = jsonResponse as? [String: Any] else { return }
				guard let groupId = getData["id"] as? String else { return }
				
				self.createGroupToFb(name: name, description: description, groupId: groupId)
				
				let subscrib = SubscriptionNetworking()
				subscrib.subscription(userID: DataProvider.shared.userId, groupID: groupId)
			} catch {
				print("error in getData/jsonResponse")
			}
		}
		task.resume()
		
		
	}
	
	func createGroupToFb (name: String, description: String, groupId: String) {
		
		let ref: DatabaseReference!
		ref = Database.database().reference()
		guard let userUid = Auth.auth().currentUser?.uid else {
			print("error, cant find UID")
			return
		}
		let groupRef = ref.child("group").child(userUid)
		let value = ["groupName": "\(name)", "groupDescription": "\(description)", "grouId": "\(groupId)"]
		groupRef.updateChildValues(value) { (error, dataRef) in
			if error != nil {
				self.handleError(error!)
			}
		}
		
	}
	
	func getGroupList (userId: String, completion: @escaping (GroupList) -> Void) {
		let queryItem = URLQueryItem(name: "uid", value: "\(userId)")
		guard var urlComp = URLComponents(string: "http://89.189.159.160:80") else {return}
		urlComp.path = "/api/group"
		urlComp.queryItems = [queryItem]
		guard let url = urlComp.url else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error != nil {
				print(error!)
				self.handleError(error!)
			}
			
			guard let data = data else {
				print("data is empty")
				return
			}
			
			do {
				let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
				if let getData = jsonData as? [String: Any] {
					if let groupIds = getData["groups"] as? [String] {
						groupIds.forEach({ (value) in
							self.mappingGroupList(groupId: value, complition: { (groupList) in
								completion(groupList)
							})
						})
					}
				}
			} catch let err {
				print(err)
			}
			
		}
		task.resume()
	}
	
	func mappingGroupList (groupId: String, complition: @escaping (GroupList) -> Void) {
		
		guard var urlComp = URLComponents(string: "http://89.189.159.160:80") else {return}
		urlComp.path = "/api/group/\(groupId)"
		guard let url = urlComp.url else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error != nil {
				print(error!)
				self.handleError(error!)
			}
			
			guard let data = data else {
				print("data is empty")
				return
			}
			
			do {
				let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonData as? [String: Any] else {
					print("error in getData mappingGP")
					return }
				guard let FirstStepTitleGroup = getData["personal"] as? [String: Any] else {
					print("firstSetp error")
					return
				}
				
				guard let SecondStepTitleGroup = FirstStepTitleGroup["descriptive"] as? [String: String] else {
					print("secondStep error")
					return
				}
				guard let groupTitle = SecondStepTitleGroup["title"] else {
					print("groupTitle error")
					return 
				}
				guard let groupDescription = SecondStepTitleGroup["description"] else {
					print("groupTitle error")
					return
				}
				
				guard let groupId = getData["id"] as? String else {
					print("groupId error")
					return
				}
				
				
				let groupInfo = GroupList(name: groupTitle, description: groupDescription, id: groupId, creator: nil, admin: nil, status: nil, date: nil, avatar: nil, statusBar: nil, nextButton: nil, membersInGroup: nil)
				complition(groupInfo)
				
			} catch let err {
				print(err)
			}
		}
		task.resume()
	}
	
	
	func handleError(_ error: Error) {
		if let errorCode = AuthErrorCode(rawValue: error._code) {
			print(errorCode.errorMessage)
		}
	}
	
	//	func getGroup () {
	//		let url = URL(string: "http://192.168.1.177:9003/user")!
	//		var request = URLRequest(url: url)
	//		request.httpMethod = "PUT"
	//		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	//
	//		let parameters: [String: Any] = [
	//			"auth": [
	//				"phone": "0",
	//				"password": "12345"
	//			],
	//			"descriptive": ["name": "Dmitry0"]
	//		]
	//		// 5d2efb0db43fdd0001e38bcf
	//
	//		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
	//		request.httpBody = jsonData
	//
	//		let task = URLSession.shared.dataTask(with: request) { data, response, error in
	//			guard let data = data,
	//				let response = response as? HTTPURLResponse,
	//				error == nil else {
	//					print("error", error ?? "Unknown error")
	//					return
	//			}
	//
	//			guard (200 ... 299) ~= response.statusCode else {
	//				print("statusCode should be 2xx, but is \(response.statusCode)")
	//				print("response = \(response)")
	//				return
	//			}
	//
	//			let responseString = String(data: data, encoding: .utf8)
	//			print("responseString = \(String(describing: responseString))")
	//
	//		}
	//		task.resume()
	//	}
	
	
}
