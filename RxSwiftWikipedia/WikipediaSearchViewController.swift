//
//  WikipediaSearchViewController.swift
//  RxSwiftWikipedia
//
//  Created by Yusuke Aono on 2019/04/02.
//  Copyright © 2019 Yusuke Aono. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class WikipediaSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = WikipediaSearchViewModel(
            searchWord: searchBar.rx.text.orEmpty.asObservable(),
            wikipediaAPI: WikipediaDefaultAPI(urlSession: .shared))
        viewModel.wikipediaPages
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, result, cell in
                cell.textLabel?.text = result.title
                cell.detailTextLabel?.text = result.url.absoluteString
            }
            .disposed(by: disposeBag)
        viewModel.error.subscribe(onNext: { error in
            if let error = error as? URLError, error.code == URLError.notConnectedToInternet {
                print(error)
            }
        })
        .disposed(by: disposeBag)
    }
}
