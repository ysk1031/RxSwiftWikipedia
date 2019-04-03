//
//  ViewModelType.swift
//  RxSwiftWikipedia
//
//  Created by Yusuke Aono on 2019/04/03.
//  Copyright © 2019 Yusuke Aono. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
