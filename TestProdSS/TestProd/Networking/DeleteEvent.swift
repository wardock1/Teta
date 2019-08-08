//
//  DeleteEvent.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 08/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation


class DeleteEvent {
	
	static func deletingEvent () {
		let detailView = DetailViewController()
		detailView.currentEventList.removeAll()
		DataProvider.shared.completionDeletingEvent?("deleted")
		
//		let url = URL(string: "http://89.189.159.160:80/api/event/rating")!
//		var request = URLRequest(url: url)
//		request.httpMethod = "DELETE"
//		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
//
//		let parameters: [String: Any] = [
//			"Group": "\(groupId)"
//		]
//
//
//		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
//		request.httpBody = jsonData
//
//		let task = URLSession.shared.dataTask(with: request) { data, response, error in
//			if error != nil {
//				print("error: \(String(describing: error))")
//			}
//			let data = data
//			do {
//				let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
//				print(jsonResponse)
//				guard let getData = jsonResponse as? [String: Any] else { return }
//				guard let eventId = getData["id"] as? String else { return }
//				print("createNewEvent id: \(eventId)")
//			} catch {
//				print("error in getData/jsonResponse, response: \(String(describing: response))")
//			}
//		}
//		task.resume()
//	}
	
	}
}
