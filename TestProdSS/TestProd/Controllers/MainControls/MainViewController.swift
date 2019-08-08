//
//  MainViewController.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

struct MainViewModel {
	
	var title: String?
	var description: String?
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
	
	let arr = [1,2,3]
	var array = [MainViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		array.append(MainViewModel(title: "Website Hosting Reviews Free", description: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu. "))
		array.append(MainViewModel(title: "Consectetaur cillium adipisicing", description: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu. "))
        setupDelegates()
        reloadPaddingOfCollectionView()
    }
    
    
    func setupDelegates () {
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func reloadPaddingOfCollectionView () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = collectionView.frame.size
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 10
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = false
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellId", for: indexPath)
		
        
        return cell
        
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCellId", for: indexPath) as? MainVCell {
			cell.titleLabel.text = array[indexPath.row].title
			cell.descriptionLabel.text = array[indexPath.row].description
			return cell
		}
		
		return UITableViewCell()
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
    
}
