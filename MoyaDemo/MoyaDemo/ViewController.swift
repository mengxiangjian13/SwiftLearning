//
//  ViewController.swift
//  MoyaDemo
//
//  Created by mengxiangjian on 2018/11/12.
//  Copyright © 2018 mengxiangjian. All rights reserved.
//

import UIKit
import Moya
import SafariServices

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = repos[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: "https://github.com/\(repos[indexPath.row].fullName)")!
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
}

class ViewController: UIViewController {
    
    let provider = MoyaProvider<Github>()
    
    var repos : [Repo] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds,
                                    style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(tableView)
        provider.request(.repo("mengxiangjian13")) { result in
            do {
                let response = try result.dematerialize()
                let array = try response.mapJSON()
                if array is Array<[String:Any]> {
                    let repoArray = array as! Array<[String:Any]>
                    self.repos = try repoArray.map {
                        return try JSONDecoder().decode(Repo.self, from: JSONSerialization.data(withJSONObject: $0, options: JSONSerialization.WritingOptions(rawValue: 0)))
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            } catch {
                print("request user repos failed!")
            }
        }
    }

    

}

struct Repo : Decodable {
    var name : String
    var fullName : String
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case fullName = "full_name"
    }
}

