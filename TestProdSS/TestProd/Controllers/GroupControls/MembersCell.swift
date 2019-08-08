//
//  MembersCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 22/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class MembersCell: UITableViewCell {
	
	
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var secondNameLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setDecorationButtons()
	}
	
	func setDecorationButtons() {

		self.backgroundColor = #colorLiteral(red: 0.5635532604, green: 0.8070442701, blue: 0.8293345495, alpha: 0.1817208904)
		
	}
	
}
