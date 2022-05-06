//  NotificationsViewController.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

class NotificationsViewController: UIViewController {

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
    
    private let spinner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView(style: .large)
        spiner.hidesWhenStopped = true
        spiner.tintColor = .label
        return spiner
    }()
    
    private lazy var noNotificationsView = NoNotificationsView()
    
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
        view.backgroundColor = .systemBackground
        navigationItem.title = "Notifications"
        view.addSubview(spinner)
        spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

//MARK: === UITableViewDelegate, UITableViewDataSource extension ===
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }

}
