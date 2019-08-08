//
//  ResponseRating.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 08/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class ResponseRating {
	
	func responsingAnswersToServer(eventID: String, subjectId: String, professionalism: Int, loyalty: Int, efficiency: Int, discipline: Int) {
		
		let url = URL(string: "http://89.189.159.160:80/api/response/rating")!
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let parameters: [String: Any] = [
			"event": eventID,
			"estimate": [
				"professionalism": professionalism,
				"loyalty": loyalty,
				"efficiency": efficiency,
				"discipline": discipline
			],
			"subject": subjectId
		]
		
		
		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				print("error: \(String(describing: error))")
			}
			let data = data
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
				print(jsonResponse)
				guard let getData = jsonResponse as? [String: Any] else {print("responsingAnswersToServer error"); return }
				//response answers to server: ["id": 5d4bf7dab43fdd00017f0349]
				print("response answers to server: \(getData)")
				
				
			} catch {
				print("error in getData/jsonResponse, response: \(String(describing: response))")
			}
		}
		task.resume()
	}
	
	func searchUnansweredUsers(eventId: String) {
		
		let url = URL(string: "http://89.189.159.160:80/api/event/rating/\(eventId)/unanswered")!
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				print("error: \(String(describing: error))")
			}
			let data = data
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
				print(jsonResponse)
				guard let getData = jsonResponse as? [String: Any] else { return }
				guard let members = getData["members"] as? [String] else { print("error in member unanswered"); return }
				if let unansweredUser = members.first {
					//					self.mappingFindedUnansweredUsers(userId: unansweredUser, completion: { (user) in
					//						print("unanswered user find, full info: \(user)")
					
					//					})
					let searchUserInfo = SearchUserNetworking()
					searchUserInfo.getUserInfo(userId: unansweredUser, completion: { (user) in
						print("in searchUnansweredUser finded userInfo: \(user)")
						DataProvider.shared.completionSearchUnansweredUser?(user)
					})
				} else {
					let nullName = User(id: nil, uid: nil, name: nil, secondName: nil, phone: nil, age: nil, avatar: nil, date: nil)
					DataProvider.shared.completionSearchUnansweredUser?(nullName)
				}
				//				DeleteEvent.deletingEvent()
				print("response unanswered users: \(members)")
				
				
			} catch {
				print("error in unanswered users, response: \(String(describing: response))")
			}
		}
		task.resume()
		
	}
	
	func mappingFindedUnansweredUsers(userId: String, completion: @escaping (User) -> Void) {
		let url = URL(string: "http://89.189.159.160:80/api/event/rating/unanswered")!
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				print("error: \(String(describing: error))")
			}
			let data = data
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
				print(jsonResponse)
				guard let getData = jsonResponse as? [String: Any] else { return }
				guard let members = getData["members"] as? [String] else { print("error in member unanswered"); return }
				if let unansweredUser = members.first {
					self.mappingFindedUnansweredUsers(userId: unansweredUser, completion: { (user) in
						print("unanswered user find, full info: \(user)")
						
					})
				}
				
				
				print("response unanswered users: \(members)")
				
				
			} catch {
				print("error in unanswered users, response: \(String(describing: response))")
			}
		}
		task.resume()
		
	}
}
