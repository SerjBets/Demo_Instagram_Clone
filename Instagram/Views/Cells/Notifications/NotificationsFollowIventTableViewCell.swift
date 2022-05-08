//  NotificationsFollowIventTableViewCell.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

protocol NotificationsFollowIventTableViewCellDelegate: AnyObject {
    func didTapFollowUnFollowButton(with model: UserNotification)
}

class NotificationsFollowIventTableViewCell: UITableViewCell {
    static let identifier = "NotificationsFollowIventTableViewCell"
    
    private var model: UserNotification?
    
//MARK: === Create UI elements ===
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.backgroundColor = .tertiarySystemBackground
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Kannywest lox you"
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    //Add all UI elements to the  superView
    private func addSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = 100
        let buttonHeight: CGFloat = 40
        profileImageView.frame  = CGRect(x: 3,
                                         y: 3,
                                         width: contentView.height - 6,
                                         height: contentView.height - 6)
        followButton.frame      = CGRect(x: contentView.width - 5 - size,
                                         y: (contentView.height - buttonHeight) / 2,
                                         width: size,
                                         height: buttonHeight)
        label.frame             = CGRect(x: profileImageView.right + 5,
                                         y: 0,
                                         width: contentView.width - size - profileImageView.width - 16,
                                         height: contentView.height)
        profileImageView.layer.cornerRadius = profileImageView.height / 2
    }
    
    @objc private func didTapFollowButton() {
        guard let model = model else { return }
        delegate?.didTapFollowUnFollowButton(with: model)
    }
    
//MARK: === init functions ===
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews()
        configureForFollow()
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: === Public ===
    public weak var delegate: NotificationsFollowIventTableViewCellDelegate?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        label.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    
    public func configure(with model: UserNotification) {
        self.model = model
        switch model.type {
        case .like(_):
            break
        case .follow(let state):
            //configure button
            switch state {
            case .following:
                //show unfollow button
                configureForFollow()
            case .not_following:
                //show follow button
                followButton.setTitle("Follow", for: .normal)
                followButton.setTitleColor(.white , for: .normal)
                followButton.layer.borderWidth = 0
                followButton.backgroundColor = .link
            }
        }
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto, completed: nil)
    }
    
    private func configureForFollow() {
        followButton.setTitle("Unfollow", for: .normal)
        followButton.setTitleColor(.label, for: .normal)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
}
