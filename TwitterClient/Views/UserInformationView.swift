//
//  UserInformationView.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/07.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit
import TwitterKit
import Kingfisher
import TTTAttributedLabel

protocol UserInformationViewDelegate: class {
    func userInformationView(_ view: UserInformationView, didTapLinkWith url: URL)
}

class UserInformationView: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: TTTAttributedLabel!
    @IBOutlet weak var followCountLabel: UILabel!
    @IBOutlet weak var followeeCountLabel: UILabel!

    @IBOutlet weak var descriptionLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelBottomConstraint: NSLayoutConstraint!
    
    var bannerViewOriginalCenter: CGPoint = .zero
    
    weak var delegate: UserInformationViewDelegate?
    
    override func awakeFromNib() {
        descriptionLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        descriptionLabel.delegate = self
        followCountLabel.text = ""
        followeeCountLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bannerViewOriginalCenter = bannerImageView.center
    }
}

// private
fileprivate extension UserInformationView {
    func updateViews(with profile: UserProfile) {
        self.followCountLabel.text = "\(profile.followCount)"
        self.followeeCountLabel.text = "\(profile.followeeCount)"
        self.bannerImageView.kf.setImage(with: profile.bannerURL)
        self.descriptionLabel.text = profile.description
        let labelWidth = UIScreen.main.bounds.width - self.descriptionLabelLeftConstraint.constant - self.descriptionLabelRightConstraint.constant
        
        let viewHeight = UILabelUtil.labelHeight(with: profile.description, width: labelWidth) + self.descriptionLabelTopConstraint.constant + self.descriptionLabelBottomConstraint.constant
        
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: viewHeight)
    }
}

// MARK: - public
extension UserInformationView {
    func update(with user: TWTRUser, completion:@escaping () -> ()) {
        nameLabel.text = user.name
        screenNameLabel.text = user.formattedScreenName
        descriptionLabel.text = nil
        iconImageView.kf.setImage(with: URL(string: user.profileImageLargeURL)!)
        
        TwitterAPIClient.getUserDescription(userID: user.userID) { [weak self] result in
            guard let strongSelf = self else {
                completion()
                return
            }
            
            switch result {
            case .Success(let profile):
                strongSelf.updateViews(with: profile)
                completion()
            case .Failure(_):
                completion()
            }
        }
    }
    
    func bannerParallax(with offsetY: CGFloat) {
        if offsetY >= -250 && offsetY <= -64 {
            let value = Math.map(value: Double(offsetY), inMin: -64, inMax: -250, outMin: 1, outMax: 2)
            bannerImageView.transform = CGAffineTransform(scaleX: CGFloat(value), y: CGFloat(value))
            
            let positionValue = Math.map(value: Double(offsetY), inMin: -64, inMax: -250, outMin: 0, outMax: 100)
            bannerImageView.center = CGPoint(x: bannerViewOriginalCenter.x, y: bannerViewOriginalCenter.y - CGFloat(positionValue))
        } else if offsetY > -64 && offsetY < 36 {
            let positionValue = Math.map(value: Double(offsetY), inMin: -64, inMax: 36, outMin: 0, outMax: 30)
            bannerImageView.center = CGPoint(x: bannerViewOriginalCenter.x, y: bannerViewOriginalCenter.y + CGFloat(positionValue))
        }
    }
}

// MARK: - TTTAttributedLabelDelegate
extension UserInformationView: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        delegate?.userInformationView(self, didTapLinkWith: url)
    }
}
