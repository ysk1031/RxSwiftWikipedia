//
//  WikipediaAPI.swift
//  RxSwiftWikipedia
//
//  Created by Yusuke Aono on 2019/04/02.
//  Copyright © 2019 Yusuke Aono. All rights reserved.
//

import Foundation
import RxSwift

protocol WikipediaAPI {
    func search(from word: String) -> Observable<[WikipediaPage]>
}

final class WikipediaDefaultAPI: WikipediaAPI {
    private let host = URL(string: "https://ja.wikipedia.org")!
    private let path = "/w/api.php"
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func search(from word: String) -> Observable<[WikipediaPage]> {
        var components = URLComponents(url: host, resolvingAgainstBaseURL: false)!
        components.path = path
        let items: [URLQueryItem] = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "list", value: "search"),
            URLQueryItem(name: "srsearch", value: word)
        ]
        components.queryItems = items
        
        print(word)
        
        let request = URLRequest(url: components.url!)
        return urlSession.rx.response(request: request)
            .map { response, data in
                do {
                    let response = try JSONDecoder().decode(WikipediaSearchResponse.self, from: data)
                    return response.query.search
                } catch {
                    throw error
                }
        }
    }
}
