//
//  UserViewModel.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/2.
//  Copyright © 2019 陈吉. All rights reserved.
//

import Foundation
import RxSwift

struct UserViewModel {
    let username = Variable("guest")
    
    lazy var userInfo = {
        return self.username.asObservable().map{ $0 == "chenji" ? "您是管理员" : "您是普通访客" }.share(replay: 1)
    }()
}
