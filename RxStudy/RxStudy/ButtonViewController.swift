//
//  ButtonViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/1.
//  Copyright © 2019 陈吉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ButtonViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
//        setButton1()
        setButton2()
    }
    
    func setButton2() {
        let button1: UIButton = UIButton(type: .system)
        button1.frame = CGRect(x: 20, y: 100, width: 50, height: 30)
        button1.setTitle("按钮1", for: .normal)
        self.view.addSubview(button1)
        
        let button2: UIButton = UIButton(type: .system)
        button2.frame = CGRect(x: 100, y: 100, width: 50, height: 30)
        button2.setTitle("按钮2", for: .normal)
        self.view.addSubview(button2)
        
        let button3: UIButton = UIButton(type: .system)
        button3.frame = CGRect(x: 180, y: 100, width: 50, height: 30)
        button3.setTitle("按钮3", for: .normal)
        self.view.addSubview(button3)
        
        button1.isSelected = true
        
        let buttons = [button1, button2, button3].map { $0! }
        //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
        let selectedButton = Observable.from(
            buttons.map { button in button.rx.tap.map { button } }
            ).merge()
        //对于每一个按钮都对selectedButton进行订阅，根据它是否是当前选中的按钮绑定isSelected属性
        for button in buttons {
            selectedButton.map { $0 == button }.bind(to: button.rx.isSelected).disposed(by: disposeBag)
        }
    }
    
    func setButton1() {
        let button: UIButton = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 100, width: 50, height: 30)
        button.setTitle("按钮", for: .normal)
        self.view.addSubview(button)
        
//        button.rx.tap.subscribe(onNext: { [weak self] in
//            self?.showMessage("按钮被点击")
//        }).disposed(by: disposeBag)
        
//        button.rx.tap.bind{ [weak self] in
//            self?.showMessage("按钮被点击")
//        }.disposed(by: disposeBag)
        
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
//        timer.map{"计数\($0)"}.bind(to: button.rx.title(for: .normal)).disposed(by: disposeBag)
        timer.map(formatTimeInterval).bind(to: button.rx.attributedTitle()).disposed(by: disposeBag)
    }
    
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
    
    func showMessage(_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
