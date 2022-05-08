//  Models.swift
//  Instagram
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import Foundation

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let profilePhoto: URL
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
    let taggedUser: [String]
    let owner: User
}

struct UserRelationship {
    let username: String
    let name: String
    let type: FollowState
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

struct EditProfileFormModel {
    let label: String
    let placeholder: String
    var value: String?
}

public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

///model of rendered post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

enum Gender {
    case male, female, other
}

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

enum FollowState {
    case following
    case not_following
}

///States of render cell
enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost)     //post
    case actions(provider: String)     //like, comment, share
    case comments(comments: [PostComment])
}

enum SettingsUrlType: String {
    case terms
    case privasy
    case help
}

///Cell model
struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

struct HomeFeedRenderViewModel {
    let header  : PostRenderViewModel
    let post    : PostRenderViewModel
    let actions : PostRenderViewModel
    let comments: PostRenderViewModel
}
