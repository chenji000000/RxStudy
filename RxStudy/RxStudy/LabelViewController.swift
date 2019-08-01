//
//  LabelViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/1.
//  Copyright © 2019 陈吉. All rights reserved.
//

// UILabel

import UIKit
import RxSwift
import RxCocoa

class LabelViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
//        setLabelText()
        setLabelAttributedText()
    }
    
    func setLabelAttributedText() {
        let label = UILabel(frame: CGRect(x: 20, y: 40, width: 300, height: 100))
        self.view.addSubview(label)
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        
        timer.map(formatTimeInterval)
            .bind(to: label.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d", arguments:[(ms / 600) % 600, (ms % 600) / 10, ms % 10])
        let attributeString = NSMutableAttributedString(string: string)
        attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Bold", size: 16), range: NSRange(location: 0, length: 5))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: 5))
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.orange, range: NSRange(location: 0, length: 5))
        return attributeString
    }
    
    func setLabelText() {
        let label = UILabel(frame: CGRect(x: 20, y: 40, width: 300, height: 100))
        self.view.addSubview(label)
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        timer.map { String(format: "%0.2d:%0.2d.%0.1d", arguments:[($0 / 600) % 600, ($0 % 600) / 10, $0 % 10])
        }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
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
