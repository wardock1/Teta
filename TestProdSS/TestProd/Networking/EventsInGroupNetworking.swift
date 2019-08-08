//
//  EventsInGroupNetworking.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 08/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class EventsInGroupNetworking {
	
	func getEventsInGroup(groupID: String, completion: (Event) -> Void) {
		
		let url = URL(string: "http://89.189.159.160:80/api/event?gid=\(groupID)&status=active")!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(DataProvider.shared.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				print("error: \(String(describing: error))")
			}
			
			guard let data = data else {
				print("data getEventsInGroup is empty")
				return
			}
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				print(jsonResponse)
				guard let getData = jsonResponse as? [String: Any] else { return }
				guard let getEvents = getData["events"] as? [String: Any] else { print("error getEvents)"); return }
				guard let getRatings = getEvents["ratings"] as? [String] else { print("error getRating)"); return }
				
				let singleInfoEvent = CreateNewEvent()
				
				_ = getRatings.map({ (value) in
					singleInfoEvent.gettingFullInfoAboutEvent(groupId: groupID, eventId: value)
				})
				
			} catch {
				print("error in getData/jsonResponse, response: \(String(describing: response))")
			}
		}
		task.resume()
	}
	
	
}
