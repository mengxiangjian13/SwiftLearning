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
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.textColor = .red
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.center = view.center
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 30))
        textField.textColor = .black
        textField.borderStyle = .line
        textField.placeholder = "input text"
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.reactor = GitHubSearchViewReactor()
        view.addSubview(textField)
        view.addSubview(label)
    }

    

}

extension ViewController : View {
        
    func bind(reactor: GitHubSearchViewReactor) {
        reactor.state.map{$0.repos?[0]}.bind(to: self.label.rx.text).disposed(by: disposeBag)
        
    textField.rx.text.map{GitHubSearchViewReactor.Action.update($0 ?? "")}.bind(to: reactor.action).disposed(by: disposeBag)
    }
}

