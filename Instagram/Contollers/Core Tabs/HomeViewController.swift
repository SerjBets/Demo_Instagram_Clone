//  HomeViewController.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
//MARK: === Create UI elements ===
    // Create TableView
    private let tableView: UITableView = {
        let tableView = UITableView()
        //Register cells
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
//MARK: === ViewController LifeCycle ===
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        createMockModel()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Debug: mockModel to test and debug
    private func createMockModel() {
        let user = User(username: "Jon",
                        bio: "hello bio",
                        name: (first: "", last: ""),
                        profilePhoto: URL(string: "http://google.com")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
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
        for _ in 0..<5 {
            var comments = [PostComment]()
            for x in 0..<2 {
                comments.append(PostComment(identifier: "\(x)", username: "Xeg", text: "Hellow Xeg", createdDate: Date(), likes: []))
            }
            
            
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                    post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                    actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                    comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModels.append(viewModel)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlNotAuthentificated()
    }
    
    //Check auth
    private func handlNotAuthentificated() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
}

// MARK: === UITableViewDelegate, UITableViewDataSource ===
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        var model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x % 4 == 0 ? (x / 4) : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        if subSection == 0 {
            //header
            return 1
        } else if subSection == 1 {
            //post
            return 1
        } else if subSection == 2 {
            //action
            return 1
        } else if subSection == 3 {
            //comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
                case .comments(let comments): return comments.count > 2 ? 2 : comments.count
                case .header, .actions, .primaryContent: return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        var model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x % 4 == 0 ? (x / 4) : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        if subSection == 0 {
            //header
            let headerModel = model.header
            switch headerModel.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 1 {
            //post
            let postModel = model.post
            switch postModel.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .header, .actions, .comments: return UITableViewCell()
            }
        }
        else if subSection == 2 {
            //action
            let actionsmodel = model.actions
            switch actionsmodel.renderType {
            case .actions(_):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostActionTableViewCell
                cell.delegate = self
                return cell
            case .header, .comments, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 3 {
            //comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(_):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
            case .header, .actions, .primaryContent: return UITableViewCell()

            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        if subSection == 0 {        //header
            return 70
        }
        else if subSection == 1 {   //post
            return tableView.width
        }
        else if subSection == 2 {   //actions
            return 60
        }
        else if subSection == 3 {   //comments
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: === IGFeedPostHeaderTableViewCellDelegate extension ===
extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        present(actionSheet, animated: true)
    }
    
    func reportPost() {
        
    }
}

//MARK: === IGFeedPostActionTableViewCellDelegate extension ===
extension HomeViewController: IGFeedPostActionTableViewCellDelegate {
    func didTapLikeButton() {
        
    }
    
    func didTapCommentButton() {
        
    }
    
    func didTapSendButton() {
        
    }
    
}
