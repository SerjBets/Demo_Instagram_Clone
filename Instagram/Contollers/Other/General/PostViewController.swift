//  PostViewController.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

/*
 Section
    - Header model
 Section
    - Post cell model
 Section
    - Action button cell model
 Section
    - Number of general models for comments
 */

class PostViewController: UIViewController {
    
    private var model: UserPost?
    private var renderModel = [PostRenderViewModel]()
    
//MARK: === Create uI elements ===
    
    //Create tableView
    private let tableView: UITableView = {
        let tableView = UITableView()
        //Register cells
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()

    //MARK: === Init ===
    init(model: UserPost?) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureModels() {
        guard let userPostModel = self.model else {return}
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(PostComment(identifier: "123_\(x)",
                                        username: "Dave",
                                        text: "Good post",
                                        createdDate: Date(),
                                        likes: []))
        }
        // Header
        renderModel.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        //Post
        renderModel.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        //Actions
        renderModel.append(PostRenderViewModel(renderType: .actions(provider: "")))
        //4 comments
        renderModel.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }
    
//MARK: === ViewController LifeCycle ===

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

//MARK: === UITableViewDelegate, UITableViewDataSource extension ===
extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModel[section].renderType {
            case .actions(_): return 1
            case .comments(let comments):  return comments.count > 4 ? 4 : comments.count
            case .primaryContent(_): return 1
            case .header(_): return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModel[indexPath.section]
        switch model.renderType {
        case .actions(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostActionTableViewCell
            return cell
        case .comments(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostGeneralTableViewCell
            return cell
        case .primaryContent(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostTableViewCell
            return cell
        case .header(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostHeaderTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModel[indexPath.section]
        switch model.renderType {
            case .actions(_): return 60
            case .comments(_):  return 50
            case .primaryContent(_): return tableView.width
            case .header(_): return 70
        }
    }
}
