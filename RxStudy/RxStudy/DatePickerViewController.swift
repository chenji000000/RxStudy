//
//  DatePickerViewController.swift
//  RxStudy
//
//  Created by 陈吉 on 2019/8/2.
//  Copyright © 2019 陈吉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DatePickerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()
    
    var ctimer: UIDatePicker!
    
    var btnstart: UIButton!
    //剩余时间（必须为 60 的整数倍，比如设置为100，值自动变为 60）
    let leftTime = Variable(TimeInterval(180))
    //当前倒计时是否结束
    let countDownStopped = Variable(true)
    
    var currentDayzoreOfDate: Date = {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = calendar.date(from: components)
        return date!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
//        setDatePicker1()
        setDatePicker2()
    }
    
    func setDatePicker2() {
        ctimer = UIDatePicker(frame: CGRect(x: 0, y: 80, width: 320, height: 200))
        ctimer.datePickerMode = UIDatePicker.Mode.countDownTimer
        self.view.addSubview(ctimer)
        
        btnstart = UIButton(type: .system)
        btnstart.frame = CGRect(x: 0, y: 300, width: 320, height: 30)
        btnstart.setTitleColor(UIColor.red, for: .normal)
        btnstart.setTitleColor(UIColor.darkGray, for: .disabled)
        self.view.addSubview(btnstart)
        
        let label = UILabel(frame: CGRect(x: 20, y: 400, width: 300, height: 100))
        self.view.addSubview(label)
        
        //剩余时间与datepicker做双向绑定
        DispatchQueue.main.async {
            self.leftTime.asObservable().bind(to: self.ctimer.rx.countDownDuration).disposed(by: self.disposeBag)
            self.ctimer.rx.date.map { [weak self] in
                TimeInterval($0.timeIntervalSince(self!.currentDayzoreOfDate))
                }.bind(to: self.leftTime).disposed(by: self.disposeBag)
        }
        
        Observable.combineLatest(leftTime.asObservable(), countDownStopped.asObservable()) { leftTimeValue, countDownStoppedValue in
            if countDownStoppedValue {
                return "开始"
            } else {
                return "倒计时开始，还有\(Int(leftTimeValue))秒"
            }
        }.bind(to: btnstart.rx.title()).disposed(by: disposeBag)
        
        countDownStopped.asDriver().drive(ctimer.rx.isEnabled).disposed(by: disposeBag)
        countDownStopped.asDriver().drive(btnstart.rx.isEnabled).disposed(by: disposeBag)
        btnstart.rx.tap.bind { [weak self] in
            self?.startClicked()
        }.disposed(by: disposeBag)
    }
    
    func startClicked() {
        self.countDownStopped.value = false
        
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).takeUntil(countDownStopped.asObservable().filter{ $0 }).subscribe { event in
            self.leftTime.value -= 1
            if(self.leftTime.value == 0) {
                print("倒计时结束")
                self.countDownStopped.value = true
                self.leftTime.value = 180
            }
        }.disposed(by: disposeBag)
    }
    
    func setDatePicker1() {
        let datePicker = UIDatePicker(frame: CGRect(x: 20, y: 100, width: 300, height: 200))
        self.view.addSubview(datePicker)
        
        let label = UILabel(frame: CGRect(x: 20, y: 400, width: 300, height: 100))
        self.view.addSubview(label)
        
        datePicker.rx.date.map { [weak self] in
            "当前选择时间: " + self!.dateFormatter.string(from: $0)
        }.bind(to: label.rx.text).disposed(by: disposeBag)
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
