//  NotificationLikeIventTableViewCell.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit
import SDWebImage

protocol NotificationLikeIventTableViewCellDelegate: AnyObject {
    func didTapRalatedPostButton(with model: UserNotification)
}

class NotificationLikeIventTableViewCell: UITableViewCell {
    static let identifier = "NotificationLikeIventTableViewCell"
    
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
        label.text = "@Jos likes your post"
        label.numberOfLines = 0
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        return button
    }()
    
    //Add all UI elements to the  superView
    private func addSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(postButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 4
        profileImageView.frame  = CGRect(x: 3,
                                         y: 3,
                                         width: contentView.height - 6,
                                         height: contentView.height - 6)
        postButton.frame        = CGRect(x: contentView.width - 5 - size,
                                         y: 2,
                                         width: size,
                                         height: size)
        label.frame             = CGRect(x: profileImageView.right + 5,
                                         y: 0,
                                         width: contentView.width - size - profileImageView.width - 16,
                                         height: contentView.height)
        profileImageView.layer.cornerRadius = profileImageView.height / 2
    }
    
    @objc private func didTapPostButton() {
        guard let model = model else { return }
        delegate?.didTapRalatedPostButton(with: model)
    }
    
//MARK: === init functions ===
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews()
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: === Public ===
    public weak var delegate: NotificationLikeIventTableViewCellDelegate?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        label.text = nil
        postButton.setTitle(nil, for: .normal)
        postButton.layer.borderWidth = 0
        postButton.backgroundColor = nil
    }
    
    public func configure(with model: UserNotification) {
        self.model = model
        switch model.type {
        case .like(post: let post):
            let tumbnail = post.tumbnailImageURL
            guard !tumbnail.absoluteString.contains("google.com") else {return}
            postButton.sd_setBackgroundImage(with: tumbnail, for: .normal, completed: nil)
        case .follow:
            break
        }
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto, completed: nil)
    }
    
}
