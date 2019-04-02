//
//  ObservableType.swift
//  RxSwiftWikipedia
//
//  Created by Yusuke Aono on 2019/04/02.
//  Copyright © 2019 Yusuke Aono. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E: EventConvertible {
    public func elements() -> Observable<E.ElementType> {
        return filter { $0.event.element != nil }.map { $0.event.element! }
    }
    
    public func errors() -> Observable<Error> {
        return filter { $0.event.error != nil }.map { $0.event.error! }
    }
}
