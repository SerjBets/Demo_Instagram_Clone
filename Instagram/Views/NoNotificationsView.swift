//  NoNotificationsView.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

class NoNotificationsView: UIView {

//MARK: === Create UI elements ===
    //Create noNotifications Label
    private let noNotificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Notifications"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    //Create bell imageView
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "bell")
        return imageView
    }()
    
    //Add all UI elements to the  superView
    private func addSubviews() {
        addSubview(noNotificationsLabel)
        addSubview(imageView)
    }
    
//MARK: === init functions ===
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame             = CGRect(x: (width - 50) / 2,
                                             y: 0,
                                             width: 50,
                                             height: 50).integral
        
        noNotificationsLabel.frame  = CGRect(x: 0,
                                             y: imageView.bottom,
                                             width: width,
                                             height: height - 50).integral
    }
}
