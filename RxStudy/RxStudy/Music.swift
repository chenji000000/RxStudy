//
//  Music.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/7/29.
//  Copyright © 2019 陈吉. All rights reserved.
//

import Foundation

struct Music {
    let name: String //歌名
    let singer: String //演唱者
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

extension Music: CustomStringConvertible {
    var description: String {
        return "name \(name) singer: \(singer)"
    }
}
