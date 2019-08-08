//
//  GroupList.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct GroupList {
	
	var name: String
	var description: String?
	var id: String?
	var creator: String?
	var admin: String?
	var status: String?
	var date: String?
	var avatar: UIImage?
	var statusBar: UIImage?
	var nextButton: UIImage?
	var membersInGroup: MembersInGroup?
	
//	init(name: String, description: String?, avatar: UIImage?, statusBar: UIImage?, nextButton: UIImage?, membersInGroup: MembersInGroup?) {
//		self.name = name
//		self.description = description
//		self.avatar = avatar
//		self.statusBar = statusBar
//		self.nextButton = nextButton
//		self.membersInGroup = membersInGroup
//	}
	
}

struct NodeData {
	
	var parent: String?
	var organization: String?
	var children: Children
	
	init(parent: String?, organization: String?, children: Children) {
		self.parent = parent
		self.organization = organization
		self.children = children
	}
	
	struct Children {
		var id: String?
		
		init(id: String?) {
			self.id = id
		}
	}
	
}
