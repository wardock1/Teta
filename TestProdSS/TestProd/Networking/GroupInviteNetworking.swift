//
//  GroupInviteNetworking.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 25/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Firebase

class GroupInviteNetworking {
	
	func inviteUser (groupId: String, receiverUserId: String) {
		
		let url = URL(string: "http://89.189.159.160:80/api/invitation")!
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let parameters: [String: Any] = [
			"receiver": "\(receiverUserId)",
			"group": "\(groupId)"
		]
		
		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			print("response: \(String(describing: response))")
			guard let data = data, error == nil else {
				print("error in inviteUser: \(String(describing: error))")
				return
			}
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: Any] else {
					print("error getData from jsonRest StringAny")
					return }
				if let getId = getData["id"] {
					print("getId from getData: \(getId)")
					
				}
				
			} catch {
				print("error in getData/GroupInvite")
			}
		}
		task.resume()
	}
	
	
	
}
