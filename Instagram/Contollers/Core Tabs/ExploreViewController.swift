//  ExploreViewController.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

class ExploreViewController: UIViewController {
    private var collectionView: UICollectionView?
    private var models = [UserPost]()
    private var tabbedSearchCollectionView: UICollectionView?
    
    //Create dimmedView
    private var dimmedView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    //Create SearchBar
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
//MARK: === ViewController LifeCycle ===
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        configureSearchBar()
        configureExploreCollection()
        configureDimmedView()
        configureTabbedSearch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tabbedSearchCollectionView?.frame = CGRect(x: 0,
                                                   y: view.safeAreaInsets.top,
                                                   width: view.width,
                                                   height: 72)
    }
    
    private func query(_ text: String) {
        // perform the search in the backend
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCancelIsSearch))
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0.4
        }) { done in
            if done {
                self.tabbedSearchCollectionView?.isHidden = false

            }
        }
    }
    
//MARK: === Configure functions ===
    private func configureTabbedSearch() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width / 3, height: 52)
        layout.scrollDirection = .horizontal
        tabbedSearchCollectionView?.backgroundColor = .yellow
        tabbedSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabbedSearchCollectionView?.isHidden = false
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else { return }
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        view.addSubview(tabbedSearchCollectionView)
    }
    
    private func configureDimmedView() {
        view.addSubview(dimmedView)
        let gesture = UIGestureRecognizer(target: self, action: #selector(didTapCancelIsSearch))
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureExploreCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.width/3, height: view.width/3)
        layout.itemSize = CGSize(width: (view.width - 4) / 3, height: (view.width - 4) / 3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
    }
    
//MARK: === Actions of buttonsTapped ===
    @objc private func didTapCancelIsSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        self.tabbedSearchCollectionView?.isHidden = true
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: { self.dimmedView.alpha = 0.4 }) { done in
            if done {
                self.dimmedView.isHidden = true

            }
        }
    }
}

//MARK: === UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ===
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView { return 0}
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        //cell.configure(with: <#T##UserPost#>)
        cell.configure(debug: "test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == tabbedSearchCollectionView {
            // change search context
            return
        }
        //let model = models[indexPath.row]
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
        let vc = PostEditorViewController()
        vc.title = post.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: === UISearchBarDelegate extension ===
extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didTapCancelIsSearch()
        guard let text = searchBar.text, !text.isEmpty else { return }
        query(text)
    }
}
