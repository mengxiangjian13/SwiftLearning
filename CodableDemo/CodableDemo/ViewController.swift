//
//  ViewController.swift
//  CodableDemo
//
//  Created by mengxiangjian on 2018/10/23.
//  Copyright © 2018 mengxiangjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let json = """
{"title":"mengxiangjian","id":"123","size":{"width":16,"height":16}}
"""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let person = Person(name: "mengxiangjian", id: 123, size: PersonSize(width: 16, height: 16))
        let data = try? JSONEncoder().encode(person)
        let jsonString = String(data: data!, encoding: .utf8)
        print(jsonString!)
        
        let me = try? JSONDecoder().decode(Person.self, from: json.data(using: .utf8) ?? Data())
        print(me!)
    }
}

struct Person : Codable {
    var name : String
    var id : Int
    var size : PersonSize
    
    init(name:String, id:Int, size:PersonSize) {
        self.name = name
        self.id = id
        self.size = size
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        var id : Int = 0
        if let _id = Person.checkType(container: container, type: Int.self, forKey: .id) {
            id = _id
        }
        if let _id = Person.checkType(container: container, type: String.self, forKey: .id) {
            id = Int(_id) ?? 0
        }
        let size = try container.decode(PersonSize.self, forKey: .size)
        self.init(name: name, id: id, size: size)
    }
    
    enum CodingKeys : String, CodingKey {
        case name = "title"
        case id
        case size
    }
    
    // 类型检查 Type Inspector
    static func checkType<T>(container: KeyedDecodingContainer<CodingKeys>, type:T.Type, forKey:CodingKeys) -> T? where T : Decodable {
        do {
            // decodeIfPresent是否可decode。如果没有该字段或者字段值为空，返回空。如果类型不对，则抛出异常，需要catch
            let r = try container.decodeIfPresent(type, forKey: forKey)
            if let r = r {
                return r
            }
        } catch {
            
        }
        return nil
    }
}

struct PersonSize : Codable {
    var width : Int
    var height : Int
}

