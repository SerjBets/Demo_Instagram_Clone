//  StorageManager.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import Foundation
import FirebaseStorage
import UIKit
import AVFoundation

public enum iGStorageManagerError: Error {
    case failedToDownload
}

public class StorageManager {
    //Singelton
    static let shared = StorageManager()
    
// MARK: === Privat ===
    private let bucket = Storage.storage().reference()
    
// MARK: === Public ===
    public func uploadUserPost(model: UserPost, completion: @escaping (Result<URL, iGStorageManagerError>) -> Void) {
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, iGStorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(.failedToDownload))
                return
            }
            completion(.success(url))
        }
    }
}
