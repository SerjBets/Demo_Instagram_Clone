//
//  NotificationsFollowIventTableViewCell.swift
//  Instagram
//
//  Created by Сергей Бец on 06.05.2022.
//

import UIKit

protocol NotificationsFollowIventTableViewCellDelegate: AnyObject {
    func didTapFollowUnFollowButton(with model: String)
}

class NotificationsFollowIventTableViewCell: UITableViewCell {
    static let identifier = "NotificationsFollowIventTableViewCell"
    
//MARK: === Create UI elements ===
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
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
    }
    
//MARK: === init functions ===
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: === Public ===
    public weak var delegate: NotificationsFollowIventTableViewCell?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        label.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    
    public func configure(with model: String) {
        
    }
    
}
