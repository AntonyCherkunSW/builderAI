//
//  Post.swift
//  BuilderAITask
//
//  Created by User on 10/7/19.
//  Copyright © 2019 aCherkun. All rights reserved.
//

import Foundation

struct PostWrapper: Codable {
    let hits: [Hit]
    let nbHits: Int?
    let page: Int?
    let nbPages: Int?
    let hitsPerPage: Int?
    let processingTimeMS: Int?
    let exhaustiveNbHits: Bool?
    let query: String?
    let params: String?
}

struct Hit: Codable {
    let created_at: String
    let title: String
    let url: URL?
    let author: String?
    let points: Int?
    let story_text: String?
    let comment_text: String?
    let num_comments: Int?
    let story_id: String?
    let story_url: URL?
    let parent_id: String?
    let created_at_i: Int?
    let _tags: [String]?
    let objectID: String?
    let _highlightResult: HighlightResult?
}

struct HighlightResult: Codable {
    let title: Result?
    let url: Result?
    let author: Result?
}

struct Result: Codable {
    let value: String?
    let matchLevel: String?
    let matchedWords: [String]?
}

struct Post {
    let title: String
    let createdAt: String
    var isOn = false
    
    init(from hit: Hit) {
        title = hit.title
        createdAt = hit.created_at
    }
}
