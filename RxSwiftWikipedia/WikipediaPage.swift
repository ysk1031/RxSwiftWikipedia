//
//  WikipediaPage.swift
//  RxSwiftWikipedia
//
//  Created by Yusuke Aono on 2019/04/02.
//  Copyright © 2019 Yusuke Aono. All rights reserved.
//

import Foundation

struct WikipediaSearchResponse: Decodable {
    let query: Query
    
    struct Query: Decodable {
        let search: [WikipediaPage]
    }
}

struct WikipediaPage {
    let id: String
    let title: String
    let url: URL
}

extension WikipediaPage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "pageid"
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = String(try container.decode(Int.self, forKey: .id))
        self.title = try container.decode(String.self, forKey: .title)
        self.url = URL(string: "https://ja.wikipedia.org/w/index.php?curid=\(id)")!
    }
}

extension WikipediaPage: Equatable {
    static func == (lhs: WikipediaPage, rhs: WikipediaPage) -> Bool {
        return lhs.id == rhs.id
    }
}
