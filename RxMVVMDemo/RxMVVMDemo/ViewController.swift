//
//  ViewController.swift
//  RxMVVMDemo
//
//  Created by mengxiangjian on 2018/11/2.
//  Copyright © 2018 mengxiangjian. All rights reserved.
//

import UIKit
import SafariServices

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
        searchController.dimsBackgroundDuringPresentation = false
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
        searchController.searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { GitHubSearchViewReactor.Action.update($0)}
            .bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map{$0.repos}.bind(to: tableView.rx.items(cellIdentifier: "cell")) {
            (row, text, cell) in cell.textLabel?.text = text
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext:{
            [weak self, weak reactor] indexPath in
            guard let `self` = self else {return}
            guard let reactor = reactor else {return}
            self.tableView.deselectRow(at: indexPath, animated: true)
            let repo = reactor.currentState.repos[indexPath.row]
            guard let url = URL(string: "https://github.com/\(repo)") else { return }
            let viewController = SFSafariViewController(url: url)
            self.searchController.present(viewController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}

