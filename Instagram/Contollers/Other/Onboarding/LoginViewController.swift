//  LoginViewController.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    struct Constants {
        static let cornerRadius: CGFloat = 8.0
        static let termsUrl              = "https://www.instagram.com/about/legal/terms/before-january-19-2013/"
        static let privasyUrl            = "https://help.instagram.com/519522125107875/?helpref=hc_fnav"
    }
    
//MARK: === UI creation functions ===
    //Create usernameTextField
    private let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username or email..."
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
    //Create passwordTextField
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
    //Create LoginButton
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Constants.cornerRadius
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        return loginButton
    }()
    //Create CreateaccountButton
    private let createAccountButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitleColor(.label, for: .normal)
        createButton.setTitle("New user? Create an Account", for: .normal)
        return createButton
    }()
    //Create TermsButton
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    //Create PrivasyButton
    private let privasyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privasy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    //Create headerView
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgrounImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgrounImageView)
        return header
    }()
    //Add all UI elements to the  superView
    private func addSubviews() {
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(termsButton)
        view.addSubview(privasyButton)
        view.addSubview(headerView)
    }
    //Create frames to all SubViews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame          = CGRect(x: 0,
                                           y: 0.0,
                                           width: view.width,
                                           height: view.height/3.0)
        usernameEmailField.frame  = CGRect(x: 25,
                                           y: headerView.bottom + 50,
                                           width: view.width - 50,
                                           height: 52.0)
        passwordField.frame       = CGRect(x: 25,
                                           y: usernameEmailField.bottom + 10,
                                           width: view.width - 50,
                                           height: 52.0)
        loginButton.frame         = CGRect(x: 25,
                                           y: passwordField.bottom + 10,
                                           width: view.width - 50,
                                           height: 52.0)
        createAccountButton.frame = CGRect(x: 25,
                                           y: loginButton.bottom + 10,
                                           width: view.width - 50,
                                           height: 52.0)
        termsButton.frame         = CGRect(x: 10,
                                           y: view.height - view.safeAreaInsets.bottom - 100,
                                           width: view.width - 20,
                                           height: 50)
        privasyButton.frame         = CGRect(x: 10,
                                           y: view.height - view.safeAreaInsets.bottom - 50,
                                           width: view.width - 20,
                                           height: 50)
        configureHeaderView()
    }
    //Configure HeaderView
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else { return }
        guard let backgroundView = headerView.subviews.first else { return }
        backgroundView.frame = headerView.bounds
        let imageView = UIImageView(image: UIImage(named: "text"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4.0,
                                 y: view.safeAreaInsets.top,
                                 width: headerView.width/2.0,
                                 height: headerView.height - view.safeAreaInsets.top)
    }
    
// MARK: === Login, CreateNewUser, Terms, Privasy buttons actions ===
    @objc private func didTapCreateAccountButton() {
        let regVC = RegistrationViewController()
        regVC.title = "Create account"
        present(UINavigationController(rootViewController: regVC), animated: true)
    }
    
    @objc private func didTapLoginButton() {
        usernameEmailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else { return }
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"), usernameEmail.contains(".") {
            email = usernameEmail
        } else {
            username = usernameEmail
        }

        AuthManager.shared.loginUser(username: username, email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "LogIn Error", message: "Unable to login you", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapTermsButton() {
        guard let url = URL(string: Constants.termsUrl) else { return }
        let sfVC = SFSafariViewController(url: url)
        present(sfVC, animated: true)
    }
    
    @objc private func didTapPrivasyButton() {
        guard let url = URL(string: Constants.privasyUrl) else { return }
        let sfVC = SFSafariViewController(url: url)
        present(sfVC, animated: true)
    }

//MARK: === ViewController LifeCycle ===
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameEmailField.delegate = self
        passwordField.delegate      = self
        addSubviews()
        view.backgroundColor = .systemBackground
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privasyButton.addTarget(self, action: #selector(didTapPrivasyButton), for: .touchUpInside)
    }
}

// MARK: === TextFieldDelegate extension ===
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
}
