//
//  Infodelegate.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 02/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation


class SingleInfoAboutInvitation {
	
	func getInfoAboutInvitationAfterSocket (invitationId: String) {
		
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
				let getData = try JSONDecoder().decode(Invite.self, from: data)
				
				let invitionData = Invitations(id: getData.id, initiator: getData.initiator, receiver: getData.receiver, group: getData.group, created: "created", status: getData.status, replieadAt: "replieadAt")
				print("info about invitationData (PROTOOLOC): \(invitionData)")
				DataProvider.shared.completionHandler?(invitionData)
			} catch let err {
				print("error: \(err)")
			}
			
		}
		task.resume()
	}
	
	
}
