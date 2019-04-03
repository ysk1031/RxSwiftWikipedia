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
    private let disposeBag = DisposeBag()
    
    private let wikipediaAPI: WikipediaAPI
    private let scheduler: SchedulerType
    
    init(wikipediaAPI: WikipediaAPI, scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        self.wikipediaAPI = wikipediaAPI
        self.scheduler = scheduler
    }
}

extension WikipediaSearchViewModel: ViewModelType {
    struct Input {
        let searchText: Observable<String>
    }
    
    struct Output {
        let wikipediaPages: Observable<[WikipediaPage]>
        let searchDescription: Observable<String>
        let error: Observable<Error>
    }
    
    func transform(input: Input) -> Output {
        let filteredText: Observable<String> = input.searchText
            .debounce(0.3, scheduler: scheduler)
            .share(replay: 1)
        
        let sequence: Observable<Event<[WikipediaPage]>> = filteredText
            .flatMapLatest { [unowned self] text -> Observable<Event<[WikipediaPage]>> in
                return self.wikipediaAPI
                    .search(from: text)
                    .materialize()
            }
            .share(replay: 1)
        let wikipediaPages: Observable<[WikipediaPage]> = sequence.elements()
        
        let searchDescription = PublishRelay<String>()

        wikipediaPages
            .withLatestFrom(filteredText) { (pages, word) -> String in
                return "\(word) \(pages.count)件"
            }
            .bind(to: searchDescription)
            .disposed(by: disposeBag)
        
        return Output(wikipediaPages: wikipediaPages,
                      searchDescription: searchDescription.asObservable(),
                      error: sequence.errors())
    }
}
