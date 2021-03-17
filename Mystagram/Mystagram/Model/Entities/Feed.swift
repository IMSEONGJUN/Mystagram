//
//  Feed.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/03/17.
//

import Foundation

struct Feed {
    let user: User
    let date: Date
    let postedImages: [String]
    let posetedText: String
    let likeCount: Int
    let reply: [Reply]
}
