//
//  TimelineTableViewCell.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/06.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit
import TwitterKit
import Kingfisher
import TTTAttributedLabel

protocol TimelineTableViewCellDelegate: class {
    func timelineTableViewCell(_ cell: TimelineTableViewCell, didTapLinkWith url: URL)
}

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: TTTAttributedLabel!
    
    @IBOutlet weak var textLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabelRightConstraint: NSLayoutConstraint!
    
    weak var delegate: TimelineTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        tweetTextLabel.delegate = self
        
        // ios8対応のためpreferredMaxLayoutWidthを設定する
        let screenWidth = UIScreen.main.bounds.width
        tweetTextLabel.preferredMaxLayoutWidth = screenWidth - textLabelLeftConstraint.constant - textLabelRightConstraint.constant
        
        // separatorを左端まで引く
        separatorInset = .zero
        layoutMargins = .zero
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
    }
}

// MARK: - public
extension TimelineTableViewCell {
    func update(with tweet: TWTRTweet) {
        nameLabel.text = tweet.author.name
        screenNameLabel.text = tweet.author.formattedScreenName
        tweetTextLabel.text = tweet.text
        
        guard let url = URL(string: tweet.author.profileImageURL) else {
            return
        }
        
        iconImageView.kf.setImage(with: url)
    }
}
// MARK: - TTTAttributedLabelDelegate
extension TimelineTableViewCell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        delegate?.timelineTableViewCell(self, didTapLinkWith: url)
    }
}
