//
//  Subscription.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class SubscriptionNetworking {
	
	func subscription(userID: String, groupID: String) {
		
		guard let url = URL(string: "http://89.189.159.160:80/api/subscription") else { return }
		
		let parametrs: [String: Any] = [
			"users": [userID],
			"groups": [groupID]
		]
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let jsonData = try! JSONSerialization.data(withJSONObject: parametrs, options: [])
		request.httpBody = jsonData
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard let data = data else { return }
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: Any] else { return }
				print("subscription getData: \(getData)")
				
			} catch let error {
				print(error)
			}
		}
		task.resume()
	}
	
	
	
	
}
