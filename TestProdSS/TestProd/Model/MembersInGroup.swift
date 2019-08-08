//
//  MembersInGroup.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 29/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import UIKit

struct MembersInGroup {
	
	var memberId: String
	var uid: Int?
	var name: String?
	var secondName: String?
	var age: Int?
	var avatar: UIImage?
	
	init(memberId: String, uid: Int?, name: String?, secondName: String?, age: Int?, avatar: UIImage?) {
		self.memberId = memberId
		self.uid = uid
		self.name = name
		self.secondName = secondName
		self.age = age
		self.avatar = avatar
	}
	
	
}
