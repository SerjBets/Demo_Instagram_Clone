//
//  UserFollowTableViewCell.swift
//  Instagram
//
//  Created by Сергей Бец on 06.05.2022.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnFollowButton(with model: UserRelationship)
}

enum FollowState {
    case following, not_following
}

struct UserRelationship {
    let username: String
    let name: String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {

    static let identifier = "UserFollowTableViewCell"
    
    private var model: UserRelationship?
    
//MARK: === Create UI elements ===
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Test"
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "@Test"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    //Add all UI elements to the  superView
    private func addSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(followButton)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelHeight = contentView.height / 2
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width / 3
        //create frame of profile image frame
        profileImageView.frame  = CGRect(x: 3,
                                         y: 3,
                                         width: contentView.height - 6,
                                         height: contentView.height - 6)
        //create frame of name label frame
        nameLabel.frame         = CGRect(x: profileImageView.right + 5,
                                         y: 0,
                                         width: contentView.width - 8 - profileImageView.width - buttonWidth,
                                         height: labelHeight)
        //create frame of username label frame
        userNameLabel.frame     = CGRect(x: profileImageView.right + 5,
                                         y: nameLabel.bottom,
                                         width: contentView.width - 8 - profileImageView.width - buttonWidth,
                                         height: labelHeight)
        //create frame of followUnFollow button frame
        followButton.frame      = CGRect(x: contentView.width - 5 - buttonWidth,
                                         y: (contentView.height - 40) / 2,
                                         width: buttonWidth,
                                         height: 40)
        
        profileImageView.layer.cornerRadius = profileImageView.height / 2.0

    }
    
//MARK: === Public ===
    public weak var delegate: UserFollowTableViewCellDelegate?
    
    public func configure(with model: UserRelationship) {
        self.model = model
        nameLabel.text = model.name
        userNameLabel.text = model.username
        switch model.type {
        case .following:
            // show unFollow button
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        case .not_following:
            //show follow button
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        userNameLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
        followButton.layer.borderWidth = 0
    }
    
//MARK: === buttons Actions ===
        @objc private func didTapFollowButton() {
            guard let model = model else { return }
            delegate?.didTapFollowUnFollowButton(with: model)
        }
    
//MARK: === init functions ===
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews()
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
