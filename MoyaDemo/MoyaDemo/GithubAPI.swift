//
//  GithubAPI.swift
//  MoyaDemo
//
//  Created by mengxiangjian on 2018/11/12.
//  Copyright © 2018 mengxiangjian. All rights reserved.
//

import Foundation
import Alamofire
import Moya

enum Github {
    case repo(String)
}

extension Github : TargetType {
    
    var method: Moya.Method {
        return .get
    }
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .repo(let name):
            return "/users/\(name)/repos"
        }
    }
    
    var sampleData: Data {
        switch self {
        case .repo:
            return Data(base64Encoded: "")!
        }
    }
    
    var task: Task {
        switch self {
        case .repo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
