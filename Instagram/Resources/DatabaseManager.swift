//  DatabaseManager.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import Foundation
import FirebaseDatabase

public class DatabaseManager {
    //Singelton
    static let shared = DatabaseManager()
    
//MARK: - Private
    private let database = Database.database().reference()

//MARK: - Public
    
    ///Check if username and email is available
    /// - Parametrs
    ///         - email: String representing email
    ///         - username: String representing username

    public func canCreateNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    ///Insert new user data to database
    /// - Parametrs
    ///         - email: String representing email
    ///         - username: String representing username
    ///         - completion: Async callback for result if database entry succeeded
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username" : username]) { error, _  in
            if error == nil {
                //succeed
                completion(true)
                return
            } else {
                //failed
                completion(false)
                return
            }
        }
    }
}
