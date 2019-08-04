//
//  SwitchViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/2.
//  Copyright © 2019 陈吉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SwitchViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
//        setSwitch1()
//        setSegment1()
//        setSegment2()
        setSwitch2()
    }
    
    func setSwitch2() {
        let switch1 = UISwitch(frame: CGRect(x: 20, y: 100, width: 40, height: 40))
        self.view.addSubview(switch1)
        switch1.rx.value.bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible).disposed(by: disposeBag)
    }
    
    func setSegment2() {
        let segment = UISegmentedControl(items: ["first", "second", "third"])
        segment.frame = CGRect(x: 20, y: 100, width: 200, height: 40)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        
        let imageView = UIImageView(frame: CGRect(x: 20, y: 200, width: 40, height: 40))
        self.view.addSubview(imageView)
        
        let showImageObservable: Observable<UIImage> = segment.rx.selectedSegmentIndex.asObservable().map {
            let images = ["first.png", "second.png", "third.png"]
            return UIImage(named: images[$0])!
        }
        
        showImageObservable.bind(to: imageView.rx.image).disposed(by: disposeBag)
    }
    
    func setSegment1() {
        let segment = UISegmentedControl(items: ["first", "second", "third"])
        segment.frame = CGRect(x: 20, y: 100, width: 200, height: 40)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        segment.rx.selectedSegmentIndex.asObservable().subscribe(onNext: {
            print("当前项：\($0)")
        }).disposed(by: disposeBag)
    }
    
    func setSwitch1() {
        let switch1 = UISwitch(frame: CGRect(x: 20, y: 100, width: 40, height: 40))
        self.view.addSubview(switch1)
        switch1.rx.isOn.asObservable().subscribe(onNext: {
            print("当前开关状态：\($0)")
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
