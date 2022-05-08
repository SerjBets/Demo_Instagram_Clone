//  ProfileInfoCollectionReusableView.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit
import GoogleDataTransport

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

final class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
     
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
//MARK: === Create UI elements ===
    //Create profilePhotoImageView
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        return imageView
    }()
    //Create postsButton
    private let postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Posts", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    //Create followingButton
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    //Create followersButton
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    //Create editProfileButton
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Your Profile", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    //Create nameLabel
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Team Cook"
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    //Create bioLabel
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "This is the first account"
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = width / 4
        let calculateButtonHight = profilePhotoSize / 2
        let calculateButtonWidth = width - 10 - profilePhotoSize
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize / 2.0
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        
        //create frame of circle profilePhotoImageView
        profilePhotoImageView.frame = CGRect(x: 5,
                                             y: 5,
                                             width: profilePhotoSize,
                                             height: profilePhotoSize).integral
        //create frame of posts button
        postsButton.frame = CGRect(x: profilePhotoImageView.right,
                                   y: 5,
                                   width: calculateButtonWidth / 3,
                                   height: calculateButtonHight).integral
        //create frame of followers button
        followersButton.frame = CGRect(x: postsButton.right,
                                       y: 5,
                                       width: calculateButtonWidth / 3,
                                       height: calculateButtonHight).integral
        //create frame of following button
        followingButton.frame = CGRect(x: followersButton.right,
                                       y: 5,
                                       width: calculateButtonWidth / 3,
                                       height: calculateButtonHight).integral
        //create frame of editProfile button
        editProfileButton.frame = CGRect(x: profilePhotoImageView.right,
                                         y: 5 + calculateButtonHight,
                                         width: calculateButtonWidth,
                                         height: calculateButtonHight).integral
        //create frame of username label
        nameLabel.frame = CGRect(x: 5,
                                 y: 5 + profilePhotoImageView.bottom,
                                 width: width - 10,
                                 height: 50).integral
        //create frame of bio button
        bioLabel.frame = CGRect(x: 5,
                                y: 5 + nameLabel.bottom,
                                width: width - 10,
                                height: bioLabelSize.height).integral
    }
    
    //Add all UI elements to the  superView
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(postsButton)
        addSubview(followingButton)
        addSubview(followersButton)
        addSubview(editProfileButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
    }
    
//MARK: === buttons Actions ===
    @objc private func didTapFollowersButton() {
        delegate?.profileHeaderDidTapFollowersButton(self)
    }
    
    @objc private func didTapFollowingButton() {
        delegate?.profileHeaderDidTapFollowingButton(self)
    }
    
    @objc private func didTapPostsButton() {
        delegate?.profileHeaderDidTapPostsButton(self)
    }
    
    @objc private func didTapeditProfileButton() {
        delegate?.profileHeaderDidTapEditProfileButton(self)
    }
    
//MARK: === init functions ===
        override init(frame: CGRect) {
            super.init(frame: frame)
            clipsToBounds = true
            backgroundColor = .systemBackground
            addSubviews()
            addButtonActions()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func addButtonActions() {
            followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
            followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
            postsButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
            editProfileButton.addTarget(self, action: #selector(didTapeditProfileButton), for: .touchUpInside)
        }
}
