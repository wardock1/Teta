//
//  CreateNewEvent.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class CreateNewEvent {
	
	func creatingNewGroup (groupId: String) {
		
		//		let someP = DataProvider.shared.nextShit
		let someP = Date(timeIntervalSinceNow: 150000)
		let ss = someP.millisecondsSince1970
		let ss2 = Int64(ss)
		
		let url = URL(string: "http://89.189.159.160:80/api/event/rating")!
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let parameters: [String: Any] = [
			"ClosingTime": ss2,
			"Group": "\(groupId)"
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
				guard let getData = jsonResponse as? [String: Any] else { return }
				guard let eventId = getData["id"] as? String else { return }
				print("createNewEvent id: \(eventId)")
				self.gettingFullInfoAboutEvent(groupId: groupId, eventId: eventId)
				//eventID Ujes: 5d4b09bfb43fdd00017f032f
				//5d4b0ac0b43fdd00017f0331
				//NWGEOuP 5d4bcb5ab43fdd00017f0340
				DataProvider.shared.completionForNewEvent?(eventId)
				
			} catch {
				print("error in getData/jsonResponse, response: \(String(describing: response))")
			}
		}
		task.resume()
	}
	
	func gettingFullInfoAboutEvent(groupId: String, eventId: String) {
		let url = URL(string: "http://89.189.159.160:80/api/event/rating/\(eventId)")!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error != nil {
				print(error!)
			}
			
			guard let data = data else {
				print("data is empty")
				return
			}
			
			do {
				let getData = try JSONDecoder().decode(Event.self, from: data)
				let singleEvent = Event(id: getData.id, creator: getData.creator, group: getData.group, data: getData.data, condition: getData.condition, date: getData.date, closed: getData.closed)
				print("singleEvent is: \(singleEvent)")
				DataProvider.shared.completionForSingleEvent?(singleEvent)
			} catch let err {
				print(err)
			}
			
		}
		task.resume()
		
		//		let task = URLSession.shared.dataTask(with: request) { data, response, error in
		//			if error != nil {
		//				print("error: \(String(describing: error))")
		//			}
		//			let data = data
		//			do {
		//				let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
		//				print(jsonResponse)
		//				guard let getData = jsonResponse as? [String: Any] else { return }
		//				print("createFullInfoNewEvent id: \(getData)")
		//
		//
		////				DataProvider.shared.completionForSingleEvent
		//			} catch {
		//				print("error in getData/jsonResponse, response: \(String(describing: response))")
		//			}
		//		}
		//		task.resume()
	}
}


extension Date {
	var millisecondsSince1970:Int64 {
		return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
	}
	
	init(milliseconds:Int64) {
		self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
	}
}
