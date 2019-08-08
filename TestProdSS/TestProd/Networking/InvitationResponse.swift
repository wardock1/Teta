//
//  InvitationResponse.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 25/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class InvitationResponse {
	
	func confirmToInvite (userId: String, completion: @escaping (String) -> Void) {
		
		guard let url = URL(string: "http://89.189.159.160:80/api/invitation/\(userId)") else {
			print("error in confirmToInvite")
			return }
		
		let parametrs: [String: Any] = [
			"status": "confirmed"
		]
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let jsonData = try! JSONSerialization.data(withJSONObject: parametrs, options: [])
		request.httpBody = jsonData
		request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			print("response: \(String(describing: response))")
			guard let data = data else { return }
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: Any] else { return }
				print("getData confirmTo invite: \(getData)")
				if let confirm = getData["ok"] as? String {
					completion(confirm)
				}
				
			} catch let error {
				print(error)
			}
			
		}
		task.resume()
	}
	
	func deniedToInvite (userId: String, completion: @escaping (String) -> Void) {
		
		guard let url = URL(string: "http://89.189.159.160:80/api/invitation/\(userId)") else {
			print("error in confirmToInvite")
			return }
		
		let parametrs: [String: Any] = [
			"status": "denied"
		]
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let jsonData = try! JSONSerialization.data(withJSONObject: parametrs, options: [])
		request.httpBody = jsonData
		request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			print("response: \(String(describing: response))")
			guard let data = data else { return }
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: Any] else { return }
				print("getData confirmTo invite: \(getData)")
				if let confirm = getData["ok"] as? String {
					completion(confirm)
				}
				
			} catch let error {
				print(error)
			}
			
		}
		task.resume()
	}
}
