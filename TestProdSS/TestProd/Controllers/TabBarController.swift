//
//  TabBarController.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
	
	let webSocketConnectiong = WebSocketNetworking()
	
//	var array = [Authentification]()
//	var token = "" {
//		didSet {
//			startConnectingToWS(token: self.token)
//		}
//	}
	
//	var socket: WebSocket!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		webSocketConnectiong.startConnectingToWS()
//		gettingToken()
//		let infoAbout = InfoAboutInvitation()
//		infoAbout.getInfoAboutInvitation(invitationId: "5d4089d9b43fdd0001586204") { (invite) in
//			print("invite is: \(invite)")
//		}
	}
	
	
//	func gettingToken() {
//		let ref: DatabaseReference!
//		ref = Database.database().reference()
//
//		guard let uid = Auth.auth().currentUser?.uid else { return }
//		let userRef = ref.child("Group").child(uid).child("token")
//		userRef.observeSingleEvent(of: .value, with: { (snapshot) in
//			if let snapshot = snapshot.value as? String {
//				self.token = snapshot
//			}
//
//		}, withCancel: nil)
//	}
	
	
//	func startConnectingToWS (token: String) {
//		socket = WebSocket(url: URL(string: "ws://89.189.159.160:9003/ws?token=\(self.token)")!)
//		var request = URLRequest(url: URL(string: "ws://89.189.159.160:9003/ws?token=\(self.token)")!)
//		request.addValue("websocket", forHTTPHeaderField: "Upgrade")
//
//		socket = WebSocket(request: request)
//
//		socket.delegate = self
//		socket.advancedDelegate = self
//		socket.connect()
//
//	}
}
