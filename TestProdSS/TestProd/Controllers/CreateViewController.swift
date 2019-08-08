//
//  CreateViewController.swift
//  TestProd
//
//  Created by Developer on 17/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Firebase

class CreateViewController: UIViewController {
	
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var phoneTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var createButton: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfigButtons()
	}
	
	func setupConfigButtons() {
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		nameTextField.layer.cornerRadius = 5
		nameTextField.layer.masksToBounds = true
		nameTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
		phoneTextField.layer.cornerRadius = 5
		phoneTextField.layer.masksToBounds = true
		phoneTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
		passwordTextField.layer.cornerRadius = 5
		passwordTextField.layer.masksToBounds = true
		passwordTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
		createButton.layer.cornerRadius = 17
		createButton.layer.masksToBounds = true
		createButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
	
	@IBAction func createTapped(_ sender: UIButton) {
		guard let phone = phoneTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { print("phone, password = nil, error"); return }
		if validate(password: passwordTextField.text!) {
			createUserToServer(phone: phone, password: password, name: name)
			let vc = storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? TabBarController
			self.present(vc!, animated: true, completion: nil)
			self.navigationController?.popViewController(animated: false)
		} else {
			alertCommand(title: "", message: "Bad password")
		}
	}
	
	// TODO: Временный костыль, переписать функцию в корректный вид
	
	func createUserToServer (phone: String, password: String, name: String) {
		
		let url = URL(string: "http://89.189.159.160:80/api/user")!
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let parameters: [String: Any] = [
			"auth": [
				"phone": phone,
				"password": password
			],
			"descriptive": ["name": name]
		]
		
		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard let data = data, error == nil else {
				self.handleError(error!)
				return
			}
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: String] else { return }
				if let getId = getData["id"] {
					print("getId from getData: \(getId)")
					self.authUserAndCreateToDataBase(login: phone, password: password, name: name, userId: getId)
				}
				
			} catch {
				print("error in getData/jsonResponse")
			}
		}
		task.resume()
		
	}
	
	
	func authUserAndCreateToDataBase (login: String, password: String, name: String, userId: String) {
		
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
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: Any] else { return }
				
				guard let token = getData["token"] as? String,
					let id = getData["id"] as? String,
					let expired = getData["expired"] as? String else {
						print("getData has error!!")
						print("some error: \(String(describing: error))")
						print("error CreateToDB getData: \(getData)")
						return
				}
				self.createUserToFireBase(phone: login, password: password, name: name, id: id, expired: expired, token: token)
				DataProvider.shared.token = token
				DataProvider.shared.userId = id
			} catch let error {
				print(error)
			}
//			GroupID GGs: 5d4ad69bb43fdd00017f031b
//			GroupID DDS: 5d4ad6acb43fdd00017f031c

//			id": "5d4ad43ab43fdd00017f0319",
//					"phone": "31"
//					"name": "Dm"
//			id: 5d4ad45bb43fdd00017f031a
//			phone 32
//			name Jms
//			tp://89.189.159.160:9003/group/5d399ab0b43fdd0001dfe7ba
			//my invities: 5d39d00cb43fdd0001dfe7d0
			//phone 33, name Jm, id: 5d407074b43fdd00015861f4
			//34, jack, 5d408012b43fdd00015861f9
			//35, Sam, 5d4084eab43fdd00015861fe31
			//36, Torm,5d4089b1b43fdd0001586203
			//37, Doin, 5d4092deb43fdd00011fbfc5
		}
		task.resume()
	}
	
	
	
	func createUserToFireBase (phone: String, password: String, name: String, id: String, expired: String, token: String) {
		
		
		let email = "\(phone)@mail.cim"
		
		
		Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
			if error != nil {
				print("error: \(String(describing: error))")
			}
			
			let ref: DatabaseReference!
			ref = Database.database().reference()
			
			guard let userUid = authDataResult?.user.uid else {
				print("error, cant find UID")
				return
			}
			let userReference = ref.child("users").child(userUid)
			let values = ["phoneInsteadOfEmail": phone , "name": name, "id": id, "expired": expired, "token": token]
			
			userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
				if error != nil {
					self.handleError(error!)
				}
			})
		}
	}
	
	
	
	@IBAction func signUpButtonTapped(_ sender: UIButton) {
		performSegue(withIdentifier: "fromLoginToRegister", sender: self)
	}
	
	
}

extension AuthErrorCode {
	var errorMessage: String {
		switch self {
		case .emailAlreadyInUse:
			return "Email уже используется с другим аккаунтом"
		case .userNotFound:
			return "Пользователь не найден"
		case .invalidEmail, .invalidSender, .invalidRecipientEmail:
			return "Попробуйте еще раз ввести корреткный email"
		case .networkError:
			return "Попробуйте еще раз"
		case .weakPassword:
			return "Пароль слишком простой, так не пойдет"
		case .wrongPassword:
			return "Пароль был введен не правильно"
		default:
			return "Что-то пошло не так, сорян"
		}
	}
}

extension UIViewController{
	func handleError(_ error: Error) {
		if let errorCode = AuthErrorCode(rawValue: error._code) {
			print(errorCode.errorMessage)
			let alert = UIAlertController(title: "Ошибка", message: errorCode.errorMessage, preferredStyle: .alert)
			
			let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
			
			alert.addAction(okAction)
			
			self.present(alert, animated: true, completion: nil)
			
		}
	}
	
	func alertCommand (title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(action)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func validate(password: String) -> Bool {
		var isUppercase = false
		var isLowerCase = false
		for char in password {
			if char.isUppercase {
				isUppercase = true
			}
			if char.isLowercase {
				isLowerCase = true
			}
		}
		return password.count >= 6 && isLowerCase && isUppercase
	}
	
}
