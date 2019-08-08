//
//  AddNewGroupController.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol testProtocol: class {
    func transforData (data: GroupList)
}

class AddNewGroupController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var nameGroupTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var createButton: UIButton!
    weak var delegate: testProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewOutlet.layer.cornerRadius = 0.5 * imageViewOutlet.bounds.size.width
        imageViewOutlet.clipsToBounds = true
        imageViewOutlet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePicker)))
        imageViewOutlet.isUserInteractionEnabled = true
        setDecorationButtons()
    }
	
	func setDecorationButtons() {
		nameGroupTextField.layer.cornerRadius = 6
		nameGroupTextField.layer.masksToBounds = true
		nameGroupTextField.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		
		descriptionTextField.layer.cornerRadius = 6
//		descriptionTextField.layer.masksToBounds = true
//		descriptionTextField.backgroundColor = .clear
		descriptionTextField.layer.borderWidth = 1
		descriptionTextField.layer.borderColor = #colorLiteral(red: 0.285771311, green: 0.7863353955, blue: 0.8415880963, alpha: 1)
		
		createButton.layer.cornerRadius = 17
		createButton.layer.masksToBounds = true
		createButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
    
    @IBAction func createButtonTapped(_ sender: Any) {
		let data = GroupList(name: nameGroupTextField.text ?? "", description: descriptionTextField.text ?? "", id: nil, creator: nil, admin: nil, status: nil, date: nil, avatar: imageViewOutlet.image, statusBar: nil, nextButton: nil, membersInGroup: nil)
		let groupNetworking = GroupNetworking()
		groupNetworking.creatingNewGroup(name: data.name, description: data.description ?? "Описание группы")
		
		
        delegate?.transforData(data: data)
        navigationController?.popViewController(animated: true)
    }
    
    
}


extension AddNewGroupController {
    
    @objc func handlePicker () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true) {
            self.imageViewOutlet.image = pickedImage
        }
    }
    
    
}
