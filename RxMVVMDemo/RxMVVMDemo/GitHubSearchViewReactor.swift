//
//  GitHubSearchViewReactor.swift
//  RxMVVMDemo
//
//  Created by mengxiangjian on 2018/11/2.
//  Copyright © 2018 mengxiangjian. All rights reserved.
//

import Foundation

import ReactorKit
import RxCocoa
import RxSwift

class GitHubSearchViewReactor: Reactor {
    
    var initialState = State()
    
    enum Action {
        case update(String)
    }
    
    enum Mutation {
        case setRepos([String], Int)
    }
    
    struct State {
        var repos : [String] = []
        var nextPage = 1
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .update(query) :
            return self.search(query: query, page: 1).takeUntil(self.action.filter{_ in true}).map {
                return Mutation.setRepos($0, $1)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setRepos(repos, nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
        }
    }
    
    func search(query: String, page: Int) -> Observable<(repos:[String], nextPage:Int)> {
        let emptyResult : ([String], Int) = ([], 1)
        guard let url = Endpoint.search(query: query, page: page).url else {
            return .just(emptyResult)
        }
        return URLSession.shared.rx.json(url: url).map {
            json in
            guard let dict = json as? [String:Any] else { return emptyResult }
            guard let items = dict["items"] as? [[String:Any]] else { return emptyResult }
            let repos =  items.compactMap { $0["full_name"] as? String}
            let nextPage = repos.isEmpty ? page : page + 1
            return (repos, nextPage)
        }
    }
    
}

struct Endpoint {
    let path : String
    let queryItems: [URLQueryItem]
    
    var url : URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.github.com"
        component.path = path
        component.queryItems = queryItems
        return component.url
    }
}

extension Endpoint {
    static func search(query:String, page:Int) -> Endpoint {
        return Endpoint(path: "/search/repositories",
                        queryItems: [URLQueryItem(name: "q", value: query),
                                     URLQueryItem(name: "page", value: "\(page)")])
    }
}
