//
//  DetailController.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/12/07.
//

import Foundation
import RxSwift

class UserDetailController: UIViewController {
    
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.index)"
    }
}

