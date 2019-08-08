//
//  ProfileController.swift
//  TestProd
//
//  Created by Developer on 16/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var moreInfo: UIButton!
	
	@IBOutlet weak var professionalismLabel: UILabel!
	@IBOutlet weak var disciplineLabel: UILabel!
	@IBOutlet weak var effenciencyLabel: UILabel!
	@IBOutlet weak var loyaltyLabel: UILabel!
	
	
	
	let settingImage = UIImage(named: "settings")
	let userRating = GetUserRating()
	let aboutUser = SearchUserNetworking()
	
	var userRatingList: UserRating!
	var userInfoList: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		ageLabel.isHidden = true
		moreInfo.setImage(settingImage, for: .normal)
        avatar.layer.cornerRadius = 0.5 * avatar.bounds.size.width
		userRating.gettingUserRating(userId: DataProvider.shared.userId)
		getUserRatig()
		aboutUserInfo()
    }
	
	func aboutUserInfo() {
		aboutUser.getUserInfo(userId: DataProvider.shared.userId) { [weak self] (user) in
			self?.userInfoList = user
			DispatchQueue.main.async {
				self?.nameLabel.text = self?.userInfoList.name
				self?.secondNameLabel.text = self?.userInfoList.secondName ?? "Second Name"
				self?.avatar.image = self?.userInfoList.avatar
			}
		}
	}
	
	func getUserRatig() {
		DataProvider.shared.completionGettingUserRating = { (userRating) in
			print("userRating in profile work: \(userRating)")
			self.userRatingList = userRating
			self.setTitleEffenciency(discipline: userRating.discipline, efficiency: userRating.efficiency, loyalty: userRating.loyalty, professionalism: userRating.professionalism)
		}
		
	}
	
	func setTitleEffenciency(discipline: Int?, efficiency: Int?, loyalty: Int?, professionalism: Int?) {
		DispatchQueue.main.async {
			if let discipline1 = discipline, let efficiency1 = efficiency, let loyalty1 = loyalty, let professionalism1 = professionalism {
				self.disciplineLabel.text = String(discipline1)
				self.effenciencyLabel.text = String(efficiency1)
				self.loyaltyLabel.text = String(loyalty1)
				self.professionalismLabel.text = String(professionalism1)
			}
		}
	}
	
	@IBAction func aboutButtonTapped(_ sender: UIButton) {
//		let vc = GroupInviteNetworking()
//		vc.inviteUser(groupId: "5d399ab0b43fdd0001dfe7ba", receiverUserId: "5d39c83bb43fdd0001dfe7cf")
//		let vc = InvitationResponse()
//		vc.confirmToInvite(userId: "5d39d00cb43fdd0001dfe7d0")
	}
	
}
