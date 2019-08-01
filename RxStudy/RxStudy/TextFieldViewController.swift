//
//  TextFieldViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/1.
//  Copyright © 2019 陈吉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextFieldViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
//        setTextField1()
//        setTextField2()
//        setTextField3()
//        setTextField4()
        setTextView()
    }
    
    func setTextView() {
        let textView = UITextView(frame: CGRect(x: 10, y: 80, width: 200, height: 200))
        textView.backgroundColor = UIColor.gray
        self.view.addSubview(textView)
        
        textView.rx.didBeginEditing.subscribe(onNext:{
            print("开始编辑")
        }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext:{
            print("结束编辑")
        }).disposed(by: disposeBag)
        
        textView.rx.didChange.subscribe(onNext:{
            print("内容发生改变")
        }).disposed(by: disposeBag)
        
        textView.rx.didChangeSelection.subscribe(onNext:{
            print("选中部分发生变化")
        }).disposed(by: disposeBag)
    }
    
    func setTextField4() {
        let userField = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        userField.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(userField)
        
        let passwordField = UITextField(frame: CGRect(x: 10, y: 150, width: 200, height: 30))
        passwordField.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(passwordField)
        
        userField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { (_) in
            passwordField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        passwordField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            passwordField.resignFirstResponder()
        }).disposed(by: disposeBag)
    }
    
    func setTextField3() {
        let inputField1 = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        inputField1.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(inputField1)
        
        let inputField2 = UITextField(frame: CGRect(x: 10, y: 150, width: 200, height: 30))
        inputField2.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(inputField2)
        
        let label = UILabel(frame: CGRect(x: 20, y: 190, width: 300, height: 30))
        self.view.addSubview(label)
        
        Observable.combineLatest(inputField1.rx.text.orEmpty, inputField2.rx.text.orEmpty) { textValue1, textValue2 -> String in
            return "你输入的号码是：\(textValue1)-\(textValue2)"
            }
            .map{ $0 }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setTextField2() {
        let inputField = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        inputField.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(inputField)
        
        let outputField = UITextField(frame: CGRect(x: 10, y: 150, width: 200, height: 30))
        outputField.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(outputField)
        
        let label = UILabel(frame: CGRect(x: 20, y: 190, width: 300, height: 30))
        self.view.addSubview(label)
        
        let button: UIButton = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 230, width: 40, height: 30)
        button.setTitle("提交", for: .normal)
        self.view.addSubview(button)
        
        let input = inputField.rx.text.orEmpty.asDriver().throttle(0.3)
        
        input.drive(outputField.rx.text).disposed(by: disposeBag)
        
        input.map { "当前字数：\($0.count)" }.drive(label.rx.text).disposed(by: disposeBag)
        
        input.map{ $0.count > 5 }.drive(button.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func setTextField1() {
        let textField = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(textField)
        textField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: {
            print("您输入的是:\($0)")
        })
            .disposed(by: disposeBag)
        
        //当文本框内容改变时，将内容输出到控制台上
//        textField.rx.text.orEmpty.changed
//            .subscribe(onNext: {
//                print("您输入的是：\($0)")
//            })
//            .disposed(by: disposeBag)
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
