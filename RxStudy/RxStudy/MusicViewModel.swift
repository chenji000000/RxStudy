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
        Music(name: "UISwitch", singer: "朴树"),
        Music(name: "双向绑定", singer: "朴树"),
        Music(name: "手势", singer: "朴树"),
        Music(name: "UIDatePicker", singer: "朴树"),
        Music(name: "UITableView", singer: "朴树"),
        Music(name: "UICollectionView", singer: "朴树")
        ])
}
