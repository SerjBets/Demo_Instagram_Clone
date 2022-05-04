//  SettingsViewController.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit
import SafariServices

///Cell model
struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

///ViewContoller to show user settings
final class SettingsViewController: UIViewController {
    
    enum SettingsUrlType: String {
        case terms
        case privasy
        case help
        
//        var rawValue: String {
//            switch self {
//                case .terms   : return "https://www.instagram.com/about/legal/terms/before-january-19-2013/"
//                case .privasy : return "https://help.instagram.com/519522125107875/?helpref=hc_fnav"
//                case .help    : return "https://help.instagram.com/contact/505535973176353"
//            }
//        }
    }
    
    private var data = [[SettingCellModel]]()

    //Create TableView
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    //Configure TableViewSettingsCells
    private func configureModels() {
        data.append([
            SettingCellModel.init(title: "Edit Profile", handler: { [weak self] in
                self?.didTapEditProfile()
            }),
            SettingCellModel.init(title: "Invite Friends", handler: { [weak self] in
                self?.didTapInviteFriends()
            }),
            SettingCellModel.init(title: "Save Original Posts", handler: { [weak self] in
                self?.didTapSaveOriginalPosts()
            })
        ])
        data.append([
            SettingCellModel.init(title: "Terms of Service", handler: { [weak self] in
                self?.openUrl(type: .terms)
            }),
            SettingCellModel.init(title: "Privasy Policy", handler: { [weak self] in
                self?.openUrl(type: .privasy)
            }),
            SettingCellModel.init(title: "Help / Feedback", handler: { [weak self] in
                self?.openUrl(type: .help)
            })
        ])
        data.append([
            SettingCellModel.init(title: "Log out", handler: { [weak self] in
                self?.didTapLogOut()
            })
        ])
            
    }
    
// MARK: === didTap functions ===
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure? You want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut { success in
                DispatchQueue.main.async {
                    if success {
                        //present log in
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    } else {
                        // failed
                        fatalError("Could not Log out user")
                    }
                }
            }
        }))
        //Assign for iPad
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriends() {
        
    }
    
    private func didTapSaveOriginalPosts() {
        
    }
    
    private func openUrl(type: SettingsUrlType) {
        let urlString: String
        switch type {
            case .terms:    urlString = "https://www.instagram.com/about/legal/terms/before-january-19-2013/"
            case .privasy:  urlString = "https://help.instagram.com/519522125107875/?helpref=hc_fnav"
            case .help:     urlString = "https://help.instagram.com/contact/505535973176353"
        }
        guard let url = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
// MARK: === viewController LifeCycle ===
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        configureModels()
    }
}


// MARK: === TableViewDelegate and TableViewDataSourse extension ===
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}
