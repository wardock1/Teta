//
//  User.swift
//  TestProd
//
//  Created by Developer on 16/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import UIKit

struct User {
    
    var id: String?
	var uid: Int?
    var name: String?
    var secondName: String?
	var phone: String?
    var age: Int?
    var avatar: UIImage?
	var date: String?
    
}

struct Authentification {
    
    var expired: String
    var id: String
    var token: String
    
}
