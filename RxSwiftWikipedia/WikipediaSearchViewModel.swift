//
//  WikipediaSearchViewModel.swift
//  RxSwiftWikipedia
//
//  Created by Yusuke Aono on 2019/04/02.
//  Copyright © 2019 Yusuke Aono. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class WikipediaSearchViewModel {
    let wikipediaPages: Observable<[WikipediaPage]>
    let error: Observable<Error>
    
    init(searchWord: Observable<String>, wikipediaAPI: WikipediaAPI) {
        let sequence = searchWord
            .filter { $0.count >= 3 }
            .flatMapLatest { wikipediaAPI.search(from: $0).materialize() }
            .share(replay: 1)
        wikipediaPages = sequence.elements()
        error = sequence.errors()
    }
}
