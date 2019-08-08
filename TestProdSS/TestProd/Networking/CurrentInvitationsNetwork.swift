//
//  CurrentInvitationsNetwork.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 30/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation


class CurrentInvitationsNetwork {
	
	
	func getCurrentInvitations (completion: @escaping (Invitations) -> Void) {
		
		guard var urlComp = URLComponents(string: "http://89.189.159.160:80") else {return}
		let queryItem = URLQueryItem(name: "", value: "true")
		urlComp.path = "/api/invitation"
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
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				if let getData = jsonResponse as? [String: Any] {
					guard let invitationsData = getData["invites"] as? [String] else {
						print("error in invitationsData")
						return
					}
//					let invData = invitationsData.map({ (value) -> Invitations in
//						Invitations(id: value, initiator: nil, receiver: nil, group: nil, created: nil, status: nil, replieadAt: nil)
//
//					})
//					let infoAboutinvInvitations = InfoAboutInvitation()
					invitationsData.forEach({ (value) in
						self.getInfoAboutInvitation(invitationId: value, completion: { (invitations) in
							completion(invitations)
						})
					})
					
					print("invitations after getData is PROTOCOL: \(String(describing: invitationsData))")
					
				}
				
				
			} catch let err {
				print(err)
			}
			
		}
		task.resume()
	}
	
	func getInfoAboutInvitation (invitationId: String, completion: @escaping (Invitations) -> Void) {
		
		guard var urlComp = URLComponents(string: "http://89.189.159.160:80") else {return}
		urlComp.path = "/api/invitation/\(invitationId)"
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
				let getData = try! JSONDecoder().decode(Invite.self, from: data)
				
				let invitionData = Invitations(id: getData.id, initiator: getData.initiator, receiver: getData.receiver, group: getData.group, created: nil, status: getData.status, replieadAt: getData.replieadAt)
				print("info about invitationData (infAbout): \(invitionData)")
				completion(invitionData)
				//				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				//				if let getData = jsonResponse as? [String: Any] {
				//					guard let id = getData["id"] as? String else {
				//						print("error in id")
				//						return
				//					}
				//					guard let initiator = getData["initiator"] as? String else {
				//						print("error in initiator")
				//						return
				//					}
				//					guard let receiver = getData["receiver"] as? String else {
				//						print("error in receiver")
				//						return
				//					}
				//					guard let group = getData["group"] as? String else {
				//						print("error in group")
				//						return
				//					}
				//					guard let created = getData["created"] as? String else {
				//						print("error in created")
				//						return
				//					}
				//					guard let status = getData["status"] as? String else {
				//						print("error in status")
				//						return
				//					}
				//					guard let replieadAt = getData["replieadAt"] as? String else {
				//						print("error in replieadAt")
				//						return
				//					}
				//					let invitationData = Invitations(id: id, initiator: initiator, receiver: receiver, group: group, created: created, status: status, replieadAt: replieadAt)
				//					completion(invitationData)
				//				}
				
				
			} 
			
		}
		task.resume()
	}

	
}
