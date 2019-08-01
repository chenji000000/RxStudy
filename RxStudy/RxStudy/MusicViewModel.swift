//
//  MusicViewModel.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/7/29.
//  Copyright © 2019 陈吉. All rights reserved.
//

import Foundation
import RxSwift

struct MusicViewModel {
    let data = Observable.just([
        Music(name: "UILabel", singer: "陈奕迅"),
        Music(name: "UITextField/UITextView", singer: "S.H.E"),
        Music(name: "UIButton", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树")
        ])
}
