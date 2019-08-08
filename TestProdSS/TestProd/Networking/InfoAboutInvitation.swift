//
//  InfoAboutInvitation.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 30/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Firebase

class InfoAboutInvitation {
	
	
	func getInfoAboutInvitationAfterSocket (invitationId: String, completion: @escaping (Invitations) -> Void) {
		
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
				
				let invitionData = Invitations(id: getData.id, initiator: getData.initiator, receiver: getData.receiver, group: getData.group, created: "created", status: getData.status, replieadAt: "replieadAt")
				print("info about invitationData (infAbout): \(invitionData)")
				//				self.saveInfoAboutInvitationToFB(id: getData.id, initiator: getData.initiator, receiver: getData.receiver, group: getData.group, created: nil, status: getData.status, replieadAt: getData.replieadAt)
				
				completion(invitionData)
			} 
			
		}
		task.resume()
	}
	
	func saveInfoAboutInvitationToFB(id: String?, initiator: String?, receiver: String?, group: String?, created: String?, status: String?, replieadAt: String?) {
		
		guard let id = id, let initiator = initiator, let receiver = receiver, let group = group, let status = status else {
			print("erorr save to FB")
			return
		}
		
		let ref: DatabaseReference!
		ref = Database.database().reference()
		guard let userUid = Auth.auth().currentUser?.uid else {
			print("error, cant find UID")
			return
		}
		let groupRef = ref.child("Invitations").child(userUid)
		let value = ["idInvitation": "\(id)", "initiator": "\(initiator)", "receiver": "\(receiver)", "group": "\(group)", "created": "\(String(describing: created))", "status": "\(status)", "replieadAt": "\(String(describing: replieadAt))"]
		groupRef.updateChildValues(value) { (error, dataRef) in
			if error != nil {
				print("errorR")
			}
			print("dataRef: \(dataRef)")
		}
		
	}
	
	
}
