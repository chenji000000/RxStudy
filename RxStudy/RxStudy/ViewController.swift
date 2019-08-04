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
            if music.name == "UILabel" {
                self.navigationController?.pushViewController(LabelViewController(), animated: true)
            } else if music.name == "UITextField/UITextView" {
                self.navigationController?.pushViewController(TextFieldViewController(), animated: true)
            } else if music.name == "UIButton" {
                self.navigationController?.pushViewController(ButtonViewController(), animated: true)
            } else if music.name == "UISwitch" {
                self.navigationController?.pushViewController(SwitchViewController(), animated: true)
            } else if music.name == "双向绑定" {
                self.navigationController?.pushViewController(BindViewController(), animated: true)
            } else if music.name == "手势" {
                self.navigationController?.pushViewController(GestureViewController(), animated: true)
            } else if music.name == "UIDatePicker" {
                self.navigationController?.pushViewController(DatePickerViewController(), animated: true)
            } else if music.name == "UITableView" {
                self.navigationController?.pushViewController(TableViewController(), animated: true)
            } else if music.name == "UICollectionView" {
                self.navigationController?.pushViewController(CollectionViewController(), animated: true)
            }
            
            print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
    }

}

