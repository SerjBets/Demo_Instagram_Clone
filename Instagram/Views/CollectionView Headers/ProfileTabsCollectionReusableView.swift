//  ProfileTabsCollectionReusableView.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

protocol ProfileTabsCollectionReusableViewDelegate: AnyObject {
    func didTapGridButtonTab()
    func didTabTaggedButtonTab()
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileTabsCollectionReusableView"
    
    struct Constants {
        static let padding: CGFloat = 8
    }
    
    public weak var delegate: ProfileTabsCollectionReusableViewDelegate?
    
//MARK: === Create UI elements ===
    private let gridButton: UIButton = {
       let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        return button
    }()
    
    private let taggedButton: UIButton = {
       let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
        return button
    }()
    
    //Add all UI elements to the  superView
    private func addSubviews() {
        addSubview(gridButton)
        addSubview(taggedButton)
        
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didTabTaggedButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = height - (Constants.padding * 2)
        let gridButtonX = (width / 2 - size) / 2
        
        //create frame of grid button
        gridButton.frame = CGRect(x: gridButtonX,
                                  y: Constants.padding,
                                  width: size,
                                  height: size)
        //create frame of tagged button
        taggedButton.frame = CGRect(x: gridButtonX + (width / 2),
                                    y: Constants.padding,
                                    width: size,
                                    height: size)
    }
    
    
//MARK: === buttons Actions ===
    @objc private func didTapGridButton() {
        gridButton.tintColor = .lightGray
        taggedButton.tintColor = .systemGray
        delegate?.didTapGridButtonTab()
    }
    
    @objc private func didTabTaggedButton() {
        gridButton.tintColor = .lightGray
        taggedButton.tintColor = .systemBlue
        delegate?.didTabTaggedButtonTab()
    }
    
    
//MARK: === init functions ===
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
