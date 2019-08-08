//
//  LoginController.swift
//  TestProd
//
//  Created by Developer on 17/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
	
	@IBOutlet weak var loginTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var createButton: UIButton!
	@IBOutlet weak var loginImage: UIImageView!
	
	var authenticationData = [Authentification]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupConfigButtons()
	}
	
	func setupConfigButtons() {
		loginButton.layer.cornerRadius = 17
		loginButton.layer.masksToBounds = true
		loginButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		createButton.layer.cornerRadius = 17
		createButton.layer.masksToBounds = true
		createButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		loginTextField.layer.cornerRadius = 5
		loginTextField.layer.masksToBounds = true
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		loginTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
		passwordTextField.layer.cornerRadius = 5
		passwordTextField.layer.masksToBounds = true
		passwordTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
	}
	
	@IBAction func loginTapped(_ sender: UIButton) {
		guard let login = loginTextField.text, let password = passwordTextField.text else { return }
		if validate(password: password) {
			authUser(login: login, password: password)
		} else {
			alertCommand(title: "", message: "Bad password")
		}
		
	}
	
	@IBAction func createTapped(_ sender: UIButton) {
		
	}
	
	
	@objc func authUser (login: String, password: String) {
		
		guard let url = URL(string: "http://89.189.159.160:80/api/auth") else { return }
		
		let parametrs: [String: Any] = [
			"phone": login,
			"password": password
		]
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let jsonData = try! JSONSerialization.data(withJSONObject: parametrs, options: [])
		request.httpBody = jsonData
		request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard let data = data else { return }
			
			if let response = response as? HTTPURLResponse, (201...401).contains(response.statusCode) {
				DispatchQueue.main.async {
					self.alertCommand(title: "", message: "bad login or password")
				}
			}
			
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: Any] else { return }
				
				guard let token = getData["token"] as? String,
					let id = getData["id"] as? String,
					let expired = getData["expired"] as? String else {
						print("getData has error!!")
						print("some error: \(String(describing: error))")
						print("getData: \(getData)")
						print("response: \(String(describing: response))")
						return
				}
				
				let datas = Authentification(expired: expired, id: id, token: token)
				self.authenticationData.append(datas)
				DataProvider.shared.token = token
				DataProvider.shared.userId = id
				
//				let ref: DatabaseReference!
//				ref = Database.database().reference()
//				guard let uid = Auth.auth().currentUser?.uid else { return }
//
//				let userRef = ref.child("users").child(uid)
//				userRef.updateChildValues(["token" : token])
				
				DispatchQueue.main.async {
					let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? TabBarController
					self.present(vc!, animated: true, completion: nil)
				}
				
			} catch let error {
				print(error)
			}
			
		}
		task.resume()
	}
	
	@objc func checkUsers () {
		
		guard let url = URL(string: "http://192.168.1.177:80/api/user/5d2efb0db43fdd0001e38bcf") else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
//		guard let token = tokenStorage else { return }
		
//		request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard let data = data else { return }
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: Any] else { return }
				print(getData)
				
				
			} catch let error {
				print(error)
			}
			
		}
		task.resume()
		
	}
	
	
	
}
