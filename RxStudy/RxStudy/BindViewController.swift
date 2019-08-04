//
//  BindViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/2.
//  Copyright © 2019 陈吉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BindViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var userVM = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setTextField()
    }
    
    func setTextField() {
        let userField = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        userField.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(userField)
        
        let label = UILabel(frame: CGRect(x: 20, y: 150, width: 300, height: 100))
        self.view.addSubview(label)
        
        userVM.username.asObservable().bind(to: userField.rx.text).disposed(by: disposeBag)
        userField.rx.text.orEmpty.bind(to: userVM.username).disposed(by: disposeBag)
        
        userVM.userInfo.bind(to: label.rx.text).disposed(by: disposeBag)
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
