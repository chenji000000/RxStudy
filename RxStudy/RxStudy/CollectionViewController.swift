//
//  CollectionViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/3.
//  Copyright © 2019 陈吉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.collectionView.backgroundColor = UIColor.white
        
        self.collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(self.collectionView)
        
        let items = Observable.just([SectionModel(model: "", items: ["Swift", "PHP", "Ruby", "Java", "C++"])])
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>> (configureCell: { (dataSource, collectionView, indexPath, element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        })
        
        items.bind(to: self.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe( onNext: { indexPath in
            print("选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
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
