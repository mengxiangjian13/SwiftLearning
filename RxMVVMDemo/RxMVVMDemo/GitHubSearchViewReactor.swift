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
        var repos : [String]?
        var nextPage = 1
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .update(query) :
            return Observable.just(Mutation.setRepos([query,query,query], 2))
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
    
}
