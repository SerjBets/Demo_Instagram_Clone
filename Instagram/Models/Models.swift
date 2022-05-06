//  Models.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import Foundation

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let tumbnailImageURL: URL
    let postUrl: URL
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUser: [User]
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}

public enum UserPostType {
    case photo, video
}

enum Gender {
    case male, female, other
}
