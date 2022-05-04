//  DatabaseManager.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import Foundation
import FirebaseAuth

public class AuthManager {
    //Singelton
    static let shared = AuthManager()
    
    //MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        /*
            - Check if username is available
            - Check if email is available
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                // Create account
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard result != nil, error == nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    // Insert account to database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        } else {
                            completion(false)
                            return
                        }
                    }
                }
            } else {
                // If username or email does not exist
                completion(false)
            }
        }
    }
     
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            //email LogIn
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        } else if let username = username {
            //username LogIn
            print(username)
        }
    }
    
    // Attempt to logout Firebase user
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print(error.localizedDescription)
            completion(false)
            return
        }
    }
}
