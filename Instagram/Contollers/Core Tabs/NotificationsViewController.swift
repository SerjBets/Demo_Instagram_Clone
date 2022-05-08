//  NotificationsViewController.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

final class NotificationsViewController: UIViewController {

    //Create TableView
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = false
        tableView.register(NotificationLikeIventTableViewCell.self,
                           forCellReuseIdentifier: NotificationLikeIventTableViewCell.identifier)
        tableView.register(NotificationsFollowIventTableViewCell.self,
                           forCellReuseIdentifier: NotificationsFollowIventTableViewCell.identifier)
        return tableView
    }()
    
    //Create spinner
    private let spinner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView(style: .large)
        spiner.hidesWhenStopped = true
        spiner.tintColor = .label
        return spiner
    }()
    
    private lazy var noNotificationsView = NoNotificationsView()
    private var models = [UserNotification]()
    
//MARK: === ViewController LifeCycle ===
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func addNoNotificationsView() {
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width / 2, height: view.width / 4)
        noNotificationsView.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Notifications"
        view.addSubview(spinner)
        spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Debug: fetch notifications
    private func fetchNotifications() {
        let user = User(username: "Jon",
                        bio: "...",
                        name: (first: "", last: ""),
                        profilePhoto: URL(string: "http://google.com")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        for x in 0..<100 {
            let post = UserPost(identifier: "",
                                postType: .photo,
                                tumbnailImageURL: URL(string: "http://google.com")!,
                                postUrl: URL(string: "http://google.com")!,
                                caption: nil,
                                likeCount: [],
                                comments: [],
                                createdDate: Date(),
                                taggedUser: [],
                                owner: user)
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_following),
                                         text: "Hellow",
                                         user: user)
            models.append(model)
        }
    }

}

//MARK: === UITableViewDelegate, UITableViewDataSource extension ===
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            //like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeIventTableViewCell.identifier,
                                                     for: indexPath) as! NotificationLikeIventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            //follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsFollowIventTableViewCell.identifier,
                                                     for: indexPath) as! NotificationsFollowIventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

}

// MARK: === NotificationLikeIventTableViewCellDelegate extension ===
extension NotificationsViewController: NotificationLikeIventTableViewCellDelegate {
    func didTapRalatedPostButton(with model: UserNotification) {
        //Open the post
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Issue: Should never get called")
        }
    }
}

//MARK: === NotificationsFollowIventTableViewCellDelegate extension ===
extension NotificationsViewController: NotificationsFollowIventTableViewCellDelegate {
    func didTapFollowUnFollowButton(with model: UserNotification) {
        //perform database update
        print(" ")
    }
    
    
}
