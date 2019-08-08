//
//  NewEventMainController.swift
//  TestProd
//
//  Created by Developer on 15/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class NewEventMainController: UIViewController {
    
    
    @IBOutlet weak var tableViewController: UITableView!
    
    var elementsArray = [NewEventElements]()
	var currentGroupId: String? {
		didSet {
			print("currentGroupID: \(String(describing: currentGroupId))")
		}
	}
	var storageGroupId: String?
    
    let images = UIImage(named: "crown")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentGroupId = storageGroupId
		
        tableViewController.delegate = self
        tableViewController.dataSource = self
        elementsInitiate(title: "Оценивание", description: "Какое-то голосование и большое описание 11", image: UIImage.init(named: "crown")!)
        elementsInitiate(title: "Опрос", description: "Какой-то опрос и большое описание 11", image: UIImage.init(named: "crown")!)
        elementsInitiate(title: "Предложение", description: "Какое-то предложение и большое описание 11", image: UIImage.init(named: "crown")!)
		
    }
    
    func elementsInitiate (title: String, description: String, image: UIImage) {
        let data = NewEventElements(title: title, description: description, image: image)
        elementsArray.append(data)
        tableViewController.reloadData()
    }
    
    
}

extension NewEventMainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCellId", for: indexPath) as? NewEventCell {
            cell.titleLabel.text = elementsArray[indexPath.row].title
            cell.descriptionLabel.text = elementsArray[indexPath.row].description
            cell.imageViewEvent.image = elementsArray[indexPath.row].image
			
			
            return cell
            
        }
        
        return UITableViewCell()
    }
    
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let name = elementsArray[indexPath.row].title
		
		switch name {
		case "Оценивание":
			print("this is golos")
//			let voteView = storyboard?.instantiateViewController(withIdentifier: "voteView") as? VoteViewController
//			navigationController?.pushViewController(voteView!, animated: true)
			if let groupId = currentGroupId {
				let createNewEvent = CreateNewEvent()
				createNewEvent.creatingNewGroup(groupId: groupId)
			}
			let alertController = UIAlertController(title: "", message: "Событие началось", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
				self.navigationController?.popViewController(animated: true)
			}
			alertController.addAction(okAction)
			present(alertController, animated: true, completion: nil)
			
			
			
		case "Опрос":
			print("this is opros")
//			let pollView = storyboard?.instantiateViewController(withIdentifier: "pollView") as? PollViewController
//			navigationController?.pushViewController(pollView!, animated: true)
		case "Предложение":
			print("this is predloz")
//			let offerView = storyboard?.instantiateViewController(withIdentifier: "offerView") as? OfferViewController
//			navigationController?.pushViewController(offerView!, animated: true)
		default: break
		}
		
		
	}
    
    
    
}
