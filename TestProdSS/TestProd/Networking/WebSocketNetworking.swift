//
//  WebSocketNetworking.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 25/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Starscream
import Firebase

class WebSocketNetworking {
	
	var socket: WebSocket!
	
	func startConnectingToWS () {
		var request = URLRequest(url: URL(string: "ws://89.189.159.160:80/api/ws?token=\(DataProvider.shared.token)")!)
		request.addValue("websocket", forHTTPHeaderField: "Upgrade")
		socket = WebSocket(request: request)
		socket.delegate = self
		socket.connect()
	}
	
	func mappingReceiveMessageFromSocket () {
		
		
	}
	
}

extension WebSocketNetworking: WebSocketDelegate {
	func websocketDidConnect(socket: WebSocketClient) {
		print("websocked connected")
	}
	
	func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		print("websocked disconnected")
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		print("websocketDidReceiveMessage text: \(text)")
			do {
				let welcome = try? JSONDecoder().decode(Welcome.self, from: text.data(using: .utf8)!)
				print("welcome: \(String(describing: welcome))")
				print("welcome dataDataId: \(String(describing: welcome?.data.data.objectID))")
				print("welcome eventType: \(String(describing: welcome?.data.eventType))")

				if let invitationId = welcome?.data.data.objectID {
					let info = SingleInfoAboutInvitation()
					info.getInfoAboutInvitationAfterSocket(invitationId: invitationId)
				}
			}
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		print("websocketDidReceiveData data: \(data)")
	}
	
	
	//	func websocketDidConnect(socket: WebSocket) {
	//		print("connected")
	//	}
	//
	//	func websocketDidDisconnect(socket: WebSocket, error: Error?) {
	//		print("disc")
	//		print("disc error: \(String(describing: error))")
	//	}
	//
	//	func websocketDidReceiveMessage(socket: WebSocket, text: String, response: WebSocket.WSResponse) {
	//		print("websocketDidReceiveMessage: \(text), resp: \(response)")
	//		print("wWEWEQEWQEQWEQWE: \(socket)")
	//		guard let data = text.data(using: .utf16),
	//			let jsonData = try? JSONSerialization.jsonObject(with: data),
	//			let jsonDict = jsonData as? [String: Any] else {
	//				return
	//		}
	//		print("jsonData: \(jsonData)")
	//		print("jsonDict: \(jsonDict)")
	//	}
	//
	//	func websocketDidReceiveData(socket: WebSocket, data: Data, response: WebSocket.WSResponse) {
	//		print("websocketDidReceiveData")
	//
	//	}
	//
	//	func websocketHttpUpgrade(socket: WebSocket, request: String) {
	//		print("httpupgr request: \(request)")
	//	}
	//
	//	func websocketHttpUpgrade(socket: WebSocket, response: String) {
	//		print("httpupgr response: \(response)")
	//	}
}
