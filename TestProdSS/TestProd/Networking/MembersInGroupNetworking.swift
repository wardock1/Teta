//
//  MembersInGroupNetworking.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 29/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation


class MembersInGroupNetworking {
	
	func getMembersInGroup (groupId: String, completion: @escaping ([User]) -> Void) {
		guard var urlComp = URLComponents(string: "http://89.189.159.160:80") else {return}
		urlComp.path = "/api/group/\(groupId)"
		guard let url = urlComp.url else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error != nil {
				print("URLSession error isnt nill")
				print(error!)
			}
			
			guard let data = data else {
				print("data is empty")
				return
			}
			
			do {
				let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
				if let getData = jsonData as? [String: Any] {
					if let groupIds = getData["members"] as? [String] {
						var arrayInfoAboutUser = [User]()
						
						var counter = 0
						for element in groupIds {
							
							self.getUserInfo(userId: element, completion: { (userInfo) in
								arrayInfoAboutUser.append(userInfo)
								counter += 1
								if counter == groupIds.count {
									completion(arrayInfoAboutUser)
								}
							})
						}
					}
				}
				
			} catch let err {
				print(err)
			}
			
		}
		task.resume()
	}
	
	func getUserInfo (userId: String, completion: @escaping (User) -> Void) {
		guard var urlComp = URLComponents(string: "http://89.189.159.160:80") else {return}
		urlComp.path = "/api/user/\(userId)"
		guard let url = urlComp.url else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error != nil {
				print("URLSession error isnt nill")
				print(error!)
			}
			
			guard let data = data else {
				print("data is empty")
				return
			}
			
			do {
				let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
				if let getData = jsonData as? [String: Any] {
					
					guard let personal = getData["personal"] as? [String: Any] else {
						print("personal error")
						return
					}
					guard let descriptive = personal["descriptive"] as? [String: Any] else {
						print("auth2 error")
						return
					}
					
					//					guard let auth = personal["auth"] as? [String: Any] else {
					//						print("auth1 error")
					//						return
					//					}
					//					guard let phone = auth["phone"] as? String else {
					//						print("error phone")
					//						return
					//					}
					
					guard let name = descriptive["name"] as? String else {
						print("error name")
						return
					}
					guard let userId = getData["id"] as? String else {
						print("userId error")
						return
					}
					
					let userInfo = User(id: userId, uid: nil, name: name, secondName: nil, phone: nil, age: nil, avatar: nil, date: nil)
					completion(userInfo)
					
				}
				
			} catch let err {
				print(err)
			}
			
		}
		task.resume()
	}
	
	
}
