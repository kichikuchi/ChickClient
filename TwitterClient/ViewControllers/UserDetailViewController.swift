//
//  UserDetailViewController.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/05.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit
import TwitterKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userInformationView: UserInformationView! {
        didSet {
            userInformationView.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
            tableView.addSubview(refreshControl)
            
            // 初期のセルを非表示にする
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    lazy var cellHeight: CGFloat = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TweetCell")!
        return cell.frame.size.height
    }()
    
    var userTweetManager: UserTweetManager!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(userTweetManager != nil, "setUser not called")
        
        setupUserInformationView(user: userTweetManager.user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBarAppearance(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationBarAppearance(isHidden: false)
    }
    
    func pullRefresh() {
        refreshControl.beginRefreshing()
        userTweetManager.reset()
        downloadTweet()
    }
}

// MARK - private
fileprivate extension UserDetailViewController {
    func setupUserInformationView(user: TWTRUser) {
        userInformationView.update(with: user) { [weak self] in
            self?.downloadTweet()
        }
    }
    
    func downloadTweet() {
        userTweetManager.getUserTimeline { [weak self] result in
            
            if let refreshControl = self?.refreshControl, refreshControl.isRefreshing {
                self?.refreshControl.endRefreshing()
            }
            
            switch result {
            case .Success(_):
                self?.tableView.reloadData()
            case .Failure(let error):
                self?.showAPIErrorAlert(error: error)
            }
        }
    }
}

// MARK: - public
extension UserDetailViewController {
    func setUser(user: TWTRUser) {
        userTweetManager = UserTweetManager(user: user)
    }
}

// MARK: - UITableViewDataSource
extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userTweetManager.shouldDownload(at: indexPath) {
            downloadTweet()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath)
        
        if let cell = cell as? UserTimelineTableViewCell {
            cell.delegate = self
            cell.update(with: userTweetManager[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTweetManager.tweetCount
    }
}

// MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - UIScrollViewDelegate
fileprivate let navigationBarHiddenThreshold: CGFloat = 40.0
extension UserDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > navigationBarHiddenThreshold {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.navigationBarAppearance(isHidden: false)
            })
            navigationItem.title = userTweetManager.user.name
        } else {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.navigationBarAppearance(isHidden: true)
                self?.navigationItem.title = ""
            })
        }
        
        // バナー画像の拡大縮小
        userInformationView.bannerParallax(with: scrollView.contentOffset.y)
    }
}

// MARK: - UserTimelineTableViewCellDelegate
extension UserDetailViewController: UserTimelineTableViewCellDelegate {
    func userTimelineTableViewCell(_ cell: UserTimelineTableViewCell, didTapLinkWith url: URL) {
        OpenURLUtil.openURL(url, with: self)
    }
}

// MARK: - UserInformationViewDelegate
extension UserDetailViewController: UserInformationViewDelegate {
    func userInformationView(_ view: UserInformationView, didTapLinkWith url: URL) {
        OpenURLUtil.openURL(url, with: self)
    }
}
