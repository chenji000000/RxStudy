//
//  TableViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/2.
//  Copyright © 2019 陈吉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TableViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
//        setUI1()
        setUI2()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.setEditing(true, animated: true)
    }
    
    func setUI2() {
        let refreshButton = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.rightBarButtonItems = [refreshButton,addButton]
        
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        self.tableView = tableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        let initialVM = TableViewModel()
        
        let refreshCommand = refreshButton.rx.tap.asObservable()
            .startWith(())  //加这个为了页面初始化时会自动加载一次数据
            .flatMapLatest(getRandomString)
            .map(TableEditingCommand.setItems)
        
        let addCommand = addButton.rx.tap.asObservable().map{ "\(arc4random())" }.map(TableEditingCommand.addItem)
        
        let movedCommand = tableView.rx.itemMoved
            .map(TableEditingCommand.moveItem)
        
        let deleteCommand = tableView.rx.itemDeleted.asObservable().map(TableEditingCommand.deleteItem)
        
        Observable.of(refreshCommand, addCommand, movedCommand, deleteCommand)
            .merge()
            .scan(initialVM) { (viewModel, command) -> TableViewModel in
                return viewModel.execute(command: command)
            }
            .startWith(initialVM)
            .map {
                [AnimatableSectionModel(model: "", items: $0.items)]
            }
            .share(replay:1)
            .bind(to: tableView.rx.items(dataSource: TableViewController.dataSource()))
            .disposed(by: disposeBag)
    }
    
    
    
    func getRandomString() -> Observable<[String]> {
        print("生成随机数据。")
        let items = (0 ..< 5).map {_ in
            "\(arc4random())"
        }
        return Observable.just(items)
    }
    
    func setUI1() {
        let refreshButton = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItems = [refreshButton,cancelButton]
        
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 56))
        self.searchBar = searchBar
        tableView.tableHeaderView = searchBar
        
        //flatMapLatest 的作用是当在短时间内（上一个请求还没回来）连续点击多次“刷新”按钮，虽然仍会发起多次请求，但表格只会接收并显示最后一次请求。避免表格出现连续刷新的现象。
        let randomResult = refreshButton.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
            .startWith(()) //加这个为了让一开始就能自动请求一次数据
            .flatMapLatest {
                self.getRandomResult().takeUntil(cancelButton.rx.tap)
            }
            .flatMap(filterResult)
            .share(replay: 1)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "条目\(indexPath.row): \(element)"
            return cell
        })
        
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    //过滤数据
    func filterResult(data:[SectionModel<String, Int>]) -> Observable<[SectionModel<String, Int>]> {
        return self.searchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance) //只有间隔超过0.5秒才发送
            .flatMapLatest{
                query -> Observable<[SectionModel<String, Int>]> in
                print("正在筛选数据（条件为：\(query)）")
                if query.isEmpty {
                    return Observable.just(data)
                } else {
                    var newData: [SectionModel<String, Int>] = []
                    for sectionModel in data {
                        let items = sectionModel.items.filter{ "\($0)".contains(query) }
                        newData.append(SectionModel(model: sectionModel.model, items: items))
                    }
                    return Observable.just(newData)
                }
        }
    }
    
    //获取数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据。。。")
        let items = (0 ..< 5).map {_ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TableViewController {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, String>> {
        return RxTableViewSectionedAnimatedDataSource(
            //设置插入、删除、移动单元格的动画效果
            animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left),
            configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "条目\(indexPath.row): \(element)"
                return cell
        },canEditRowAtIndexPath: { _, _ in
            return true //单元格可删除
        }, canMoveRowAtIndexPath: { _, _ in
            return true //单元格可移动
        }
        )
    }
}
