//
//  QuotesModel.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation

struct QuoteModel: Decodable {
    var quotes: [Quote]
}
struct Quote: Decodable {
    var id: Int
    var author: String
    var body: String
    var upvotes_count: Int
    var downvotes_count: Int
}
struct Typeheads: Decodable {
    var tags: [Tag]
}
struct Tag: Decodable {
    var name: String
    var count: Int
}
