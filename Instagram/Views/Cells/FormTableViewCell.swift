//  FormTableViewCell.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

protocol FormTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell {
    static let identifier = "FormTableViewCell"
    
//MARK: === Create UI elements ===
    private var model: EditProfileFormModel?
    
    private let formlabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formlabel.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)
        field.frame     = CGRect(x: formlabel.right + 5,
                                 y: 0,
                                 width: contentView.width - 10 - formlabel.width,
                                 height: contentView.height)
    }

//MARK: === init functions ===
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formlabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: === Public ===
    public weak var delegate: FormTableViewCellDelegate?

    public func configure(with model: EditProfileFormModel) {
        self.model = model
        formlabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formlabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
}

// MARK: === UITextFieldDelegate extension ===
extension FormTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else { return true }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
}
