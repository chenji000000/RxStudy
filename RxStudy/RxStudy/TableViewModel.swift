//
//  TableViewModel.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/2.
//  Copyright © 2019 陈吉. All rights reserved.
//

import Foundation

enum TableEditingCommand {
    case setItems(items: [String]) //设置表格数据
    case addItem(item: String) //新增数据
    case moveItem(from: IndexPath, to:IndexPath) //移动数据
    case deleteItem(IndexPath) //删除数据
}

struct TableViewModel {
    var items: [String]
    
    init(items: [String] = []) {
        self.items = items
    }
    
    func execute(command: TableEditingCommand) -> TableViewModel {
        switch command {
        case .setItems(let items):
            print("设置表格数据。")
            return TableViewModel(items: items)
        case .addItem(let item):
            print("新增数据项。")
            var items = self.items
            items.append(item)
            return TableViewModel(items: items)
        case .moveItem(let from, let to):
            print("移动数据项。")
            var items = self.items
            items.insert(items.remove(at: from.row), at: to.row)
            return TableViewModel(items: items)
        case .deleteItem(let indexpath):
            print("删除数据项。")
            var items = self.items
            items.remove(at: indexpath.row)
            return TableViewModel(items: items)
        }
    }
}
