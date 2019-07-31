//
//  ViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/7/29.
//  Copyright © 2019 陈吉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
        return tableView
    }()
    
    let musicViewModel = MusicViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUI()
        setData()
    }
    
    func setUI() {
        self.view.addSubview(tableView)
    }

    func setData() {
        musicViewModel.data
        musicViewModel.data.bind(to: tableView.rx.items(cellIdentifier:"musicCell")) {
            _, music, cell in
            cell.textLabel?.text = music.name
            cell.detailTextLabel?.text = music.singer
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { (music) in
            print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
    }

}

