//  RegistrationViewController.swift
//  LoginViewController.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

class RegistrationViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
//MARK: === UI creation functions ===
    //Create username TextField
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    //Create email TextField
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    //Create password TextField
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    //Create register Button
    private let registerButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Sign Up", for: .normal)
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Constants.cornerRadius
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        return loginButton
    }()
    //Add all UI elements to the  superView
    private func addSubviews() {
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.backgroundColor = .systemBackground
    }
    //Create frames to all SubViews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameField.frame  = CGRect(x: 20,
                                      y: view.safeAreaInsets.top + 100,
                                      width: view.width - 40,
                                      height: 52.0)
        emailField.frame     = CGRect(x: 20,
                                      y: usernameField.bottom + 10,
                                      width: view.width - 40,
                                      height: 52.0)
        passwordField.frame  = CGRect(x: 20,
                                      y: emailField.bottom + 10,
                                      width: view.width - 40,
                                      height: 52.0)
        registerButton.frame = CGRect(x: 20,
                                      y: passwordField.bottom + 10,
                                      width: view.width - 40,
                                      height: 52.0)
    }
    
// MARK: === Register button action ===
    @objc private func didTapRegisterButton() {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let username = usernameField.text, !username.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else { return }
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { registered in
            DispatchQueue.main.async {
                if registered {
                    //good to go
                } else {
                    //failed
                }
            }
        }
    }

// MARK: === ViewController LifeCycle ===
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate  = self
        emailField.delegate     = self
        passwordField.delegate  = self
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        addSubviews()
    }

}
// MARK: - TextFieldDelegate extension -
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            didTapRegisterButton()
        }
        return true
    }
}
