//  IGFeedPostHeaderTableViewCell.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit
import SDWebImage

protocol IGFeedPostHeaderTableViewCellDelegate: AnyObject {
    func didTapMoreButton()
}

class IGFeedPostHeaderTableViewCell: UITableViewCell {
    static let identifier = "IGFeedPostHeaderTableViewCell"
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    private func addSubviews() {
        contentView.addSubview(profilePhotoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
    }
    
    @objc private func didTapMoreButton() {
        delegate?.didTapMoreButton()
    }
    
    public weak var delegate: IGFeedPostHeaderTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        addSubviews()
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: User) {
        usernameLabel.text = model.username
        profilePhotoImageView.image = UIImage(systemName: "person.circle")
        //profilePhotoImageView.sd_setImage(with: model.profilePhoto, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 4
        profilePhotoImageView.frame = CGRect(x: 2,
                                             y: 2,
                                             width: size,
                                             height: size)
        moreButton.frame = CGRect(x: contentView.width - size,
                                  y: 2,
                                  width: size,
                                  height: size)
        usernameLabel.frame = CGRect(x: profilePhotoImageView.right + 10,
                                     y: 2,
                                     width: contentView.width - (size * 2) - 15 ,
                                     height: contentView.height - 4)
        profilePhotoImageView.layer.cornerRadius = size / 2
    }
    
    override func prepareForReuse() {
        usernameLabel.text = nil
        profilePhotoImageView.image = nil
    }
}
