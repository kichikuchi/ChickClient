//
//  TimelineViewController.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/05.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit
import TwitterKit

class TimelineViewController: UIViewController {

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
    
    let tweetManager = TweetManager()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadTweet()
        
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func pullRefresh() {
        refreshControl.beginRefreshing()
        tweetManager.reset()
        downloadTweet()
    }
}

// MARK: - private
fileprivate extension TimelineViewController {
    func downloadTweet() {
        tweetManager.getTimeline { [weak self] result in
            
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

// MARK: - UITableViewDataSource
extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetManager.tweetCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tweetManager.shouldDownload(at: indexPath) {
            downloadTweet()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath)
        
        if let cell = cell as? TimelineTableViewCell {
            cell.delegate = self
            cell.update(with: tweetManager[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TimelineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tweet = tweetManager[indexPath.row]
        let viewController = UserDetailViewController.fromStoryboard() as! UserDetailViewController
        viewController.setUser(user: tweet.author)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UserTimelineTableViewCellDelegate
extension TimelineViewController: TimelineTableViewCellDelegate {
    func timelineTableViewCell(_ cell: TimelineTableViewCell, didTapLinkWith url: URL) {
        OpenURLUtil.openURL(url, with: self)
    }
}
