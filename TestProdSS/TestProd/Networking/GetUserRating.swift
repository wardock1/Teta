//
//  GetUserRating.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 08/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class GetUserRating {
	
	func gettingUserRating(userId: String) {
		
		let url = URL(string: "http://89.189.159.160:80/api/user/\(userId)/rating")!
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				print("error: \(String(describing: error))")
			}
			guard let data = data else {
				print("data is empty gettingUserRating")
				return
			}
			
			do {
//				let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
//				print(jsonResponse)
//				guard let getData = jsonResponse as? [String: Any] else { return }
//				print("userRating is: \(getData)")
				let jsonResponse = try JSONDecoder().decode(UserRating.self, from: data)
				let userRating = UserRating(discipline: jsonResponse.discipline ?? 0, efficiency: jsonResponse.efficiency ?? 0, loyalty: jsonResponse.loyalty ?? 0, professionalism: jsonResponse.professionalism ?? 0)
				print("userRating is: \(userRating)")
				DataProvider.shared.completionGettingUserRating?(userRating)
				
			} catch {
				print("error in unanswered users, response: \(String(describing: response))")
			}
		}
		task.resume()
	}
	
	
	
}
