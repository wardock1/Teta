//
//  SearchUserNetworking.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 30/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class SearchUserNetworking {
	
	func searchUser (userName: String, completion: @escaping (User) -> Void) {
		let queryItem = URLQueryItem(name: "name", value: "\(userName)")
		guard var urlComp = URLComponents(string: "http://89.189.159.160:80") else {return}
		urlComp.path = "/api/user"
		urlComp.queryItems = [queryItem]
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
					guard let userId = getData["users"] as? [String] else {
						print("userId error")
						return
					}
					print("getData userInfo: \(getData)")
					userId.forEach({ (value) in
						self.getUserInfo(userId: value, completion: { (user) in
							print("user is: \(user)")
							completion(user)
						})
					})
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
//					guard let auth = personal["auth"] as? [String: Any] else {
//						print("auth error")
//						return
//					}
//					guard let phone = auth["phone"] as? String else {
//						print("error phone")
//						return
//					}
					
					guard let descriptive = personal["descriptive"] as? [String: Any] else {
						print("auth error")
						return
					}
					guard let name = descriptive["name"] as? String else {
						print("error name")
						return
					}
					guard let image = personal["image"] as? String else {
						print("image error userInfo")
						return
					}
					guard let userId = getData["id"] as? String else {
						print("userId error")
						return
					}
					guard let ss = image.fromBase64() else {
						print("image error")
						return
					}
					
					let userInfo = User(id: userId, uid: nil, name: name, secondName: nil, phone: nil, age: nil, avatar: ss, date: nil)
					completion(userInfo)
					
				}
				
			} catch let err {
				print(err)
			}
			
		}
		task.resume()
	}
}

extension String {
	
	func fromBase64() -> UIImage? {
		guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
			return nil
		}
		
		return UIImage(data: data as Data, scale: CGFloat(String.Encoding.utf8.rawValue))
	}
	
	func toBase64() -> String? {
		guard let data = self.data(using: String.Encoding.utf8) else {
			return nil
		}
		
		return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
	}
}
