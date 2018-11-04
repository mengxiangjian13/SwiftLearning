//
//  ViewController.swift
//  RxMVVMDemo
//
//  Created by mengxiangjian on 2018/11/2.
//  Copyright © 2018 mengxiangjian. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(tableView)
        
        navigationItem.searchController = searchController
        tableView.scrollIndicatorInsets.top = tableView.contentInset.top
        
        self.reactor = GitHubSearchViewReactor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(false)
        searchController.isActive = true
        searchController.isActive = false
        UIView.setAnimationsEnabled(true)
    }
}

extension ViewController : View {
        
    func bind(reactor: GitHubSearchViewReactor) {
        searchController.searchBar.rx.text.map {
            GitHubSearchViewReactor.Action.update($0 ?? "")
        }.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map{$0.repos}.bind(to: tableView.rx.items(cellIdentifier: "cell")) {
            (row, text, cell) in cell.textLabel?.text = text
        }.disposed(by: disposeBag)
    }
}

