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
        case update(String?)
        case loadMore
    }
    
    enum Mutation {
        case setRepos([String], Int)
        case setMoreRepos([String], Int)
        case setIsLoading(Bool)
        case setQuery(String?)
    }
    
    struct State {
        var repos : [String] = []
        var nextPage = 1
        
        var query : String?
        var isLoading = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .update(query) :
            guard query?.lengthOfBytes(using: .utf8) ?? 0 > 0 else {return Observable.empty()}
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                self.search(query: query, page: 1).map {
                    return Mutation.setRepos($0, $1)
                }])
        case .loadMore :
            guard !self.currentState.isLoading else {return Observable.empty()}
            guard let query = self.currentState.query else {return Observable.empty()}
            guard self.currentState.nextPage > 0 else {return Observable.empty()}
            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                self.search(query: query, page: self.currentState.nextPage).map {
                    return Mutation.setMoreRepos($0, $1)
                },
                Observable.just(Mutation.setIsLoading(false))
            ])}
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setRepos(repos, nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
        case let .setMoreRepos(repos, nextPage):
            var newState = state
            newState.repos.append(contentsOf: repos)
            newState.nextPage = nextPage
            newState.isLoading = false
            return newState
        case let .setIsLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            return newState
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
        }
    }
    
    func search(query: String?, page: Int) -> Observable<(repos:[String], nextPage:Int)> {
        let emptyResult : ([String], Int) = ([], 1)
        guard let query = query else {
            return .just(emptyResult)
        }
        guard let url = Endpoint.search(query: query, page: page).url else {
            return .just(emptyResult)
        }
        return URLSession.shared.rx.json(url: url).map {
            json in
            guard let dict = json as? [String:Any] else { return emptyResult }
            guard let items = dict["items"] as? [[String:Any]] else { return emptyResult }
            let repos =  items.compactMap { $0["full_name"] as? String}
            let nextPage = repos.isEmpty ? 0 : page + 1
            return (repos, nextPage)
        }.catchErrorJustReturn(([], page))
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
