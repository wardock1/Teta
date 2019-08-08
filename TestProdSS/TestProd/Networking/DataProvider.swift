//
//  DataProvider.swift
//  TestProd
//
//  Created by Developer on 16/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation


class DataProvider {
    
    static let shared = DataProvider()
	
	var completionHandler: ((Invitations) -> Void)?
	var completionForNewEvent: ((String) -> Void)?
	var completionForSingleEvent: ((Event) -> Void)?
	var completionGettingUserRating: ((UserRating) -> Void)?
	var completionSearchUnansweredUser: ((User) -> Void)?
	var completionDeletingEvent: ((String) -> Void)?
	
	var nextShit: Date?
	var eventList = [Event]()
	
	var discipline: Int? {
		didSet {
			print("discipline: \(String(describing: discipline))")
		}
	}
	var professionalism: Int? {
		didSet {
			print("professionalism \(String(describing: professionalism))")
		}
	}
	var loyalty: Int? {
		didSet {
			print("loyalty: \(String(describing: loyalty))")
		}
	}
	var efficiency: Int? {
		didSet {
			print("efficiency: \(String(describing: efficiency))")
		}
	}
	
	var token = "" {
		didSet {
			print("token was changed Dataprovider: \(self.token)")
		}
	}
	var userId = "" {
		didSet {
			print("userId was changed Dataprovider: \(self.userId)")
		}
	}
	
	func getToken (token: String) -> String {
		return token
	}
	
    func fetchData (completion: @escaping () -> Void) {
        
    }
    
    
    func createUser () {
    
    }
    
}
