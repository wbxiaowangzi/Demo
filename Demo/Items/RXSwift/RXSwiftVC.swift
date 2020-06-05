//
//  RXSwiftVC.swift
//  Demo
//
//  Created by YingZi on 2018/11/7.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXSwiftVC: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!

    @IBOutlet weak var userNameAlertLab: UILabel!

    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var passwordAlertLab: UILabel!

    @IBOutlet weak var loginBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTF.endEditing(true)
        passwordTF.endEditing(true)
    }
    @IBAction func btnClick(_ sender: UIButton) {
//        empty()
//        just()
//        of()
//        from()
//        creat()
//        range()
//        repeatElement()
//        genreate()
        practiceMap()
    }
}

extension RXSwiftVC {
    func bindViewModel(){
        let vm = TheViewModel()
        
        //最近的一个
        vm.behaviorSubject.onNext("behaviorSubject  1")
        vm.behaviorSubject.onNext("behaviorSubject  2")
        vm.behaviorSubject.onNext("behaviorSubject  3")
        vm.behaviorSubject.subscribe(onNext: { (info) in
            print(info)
        }).disposed(by: disposeBag)
        
        //完成前的一个（不管是订阅前还是订阅后的完成）
        vm.asyncSubject.onNext("asyncSubject  1")
        vm.asyncSubject.onNext("asyncSubject  2")
        vm.asyncSubject.onNext("asyncSubject  3")
//        vm.asyncSubject.onCompleted()
        vm.asyncSubject.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        vm.asyncSubject.onNext("asyncSubject  4")
        vm.asyncSubject.onCompleted()
        
        ///只有以后发生的消息
        vm.publicSubject.onNext("publicSubject  1")
        vm.publicSubject.onNext("publicSubject  2")
        vm.publicSubject.onNext("publicSubject  3")
        vm.publicSubject.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        vm.publicSubject.onNext("publicSubject  4")

        //最近的n个和以后的
        vm.replaySubject.onNext("replaySubject  1")
        vm.replaySubject.onNext("replaySubject  2")
        vm.replaySubject.onNext("replaySubject  3")
        vm.replaySubject.onNext("replaySubject  4")
        vm.replaySubject.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        //最近的一个和以后的
        vm.variableSubject.value = "variableSubject  1"
        vm.variableSubject.value = "variableSubject  2"
        vm.variableSubject.value = "variableSubject  3"
        vm.variableSubject.asObservable().subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        vm.variableSubject.value = "variableSubject  4"

    }
    
}

extension RXSwiftVC {
    
    func never() {
        let neverSequence = Observable<String>.never()
        neverSequence.subscribe {_ in
            print("This iwill never be printed")
            }.disposed(by: disposeBag)
    }
    
    func empty() {
        Observable<Int>.empty().subscribe { event in
            print(event)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
            }.disposed(by: disposeBag)
    }
    
    func just() {
        Observable.just("aaaa").subscribe {event in
            print(event)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
            }.disposed(by: disposeBag)
    }
    
    func of()  {
        Observable.of(1, 2, 3,4,5).subscribe( {event in
            print(event)
        }).disposed(by: disposeBag)
        
        Observable.of(1, 2, 3,4,5).subscribe(onNext: { (a) in
            print(a)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: disposeBag)
    }
    
    func from() {
        Observable.from([1, 2, 3,4,5,6]).subscribe(onNext: { (a) in
            print(a)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: disposeBag)
    }
    
    func creat() {
        let se = Observable<Any>.create { (observer) -> Disposable in
            observer.on(.next("1234"))
            observer.on(.completed)
            return Disposables.create()
        }
        se.subscribe( {
            print($0)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: disposeBag)
        
    }
    
    func range() {
        Observable.range(start: 1, count: 10).subscribe( {
            print($0)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: disposeBag)
        
        Observable.range(start: 1, count: 10).subscribe(onNext: { (a) in
            print(a)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: disposeBag)
    }
    
    func repeatElement() {
        Observable.repeatElement("6").take(6).subscribe(onNext: {
            print($0)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: disposeBag)
    }
    
    func genreate() {
        Observable.generate(initialState: 0, condition: {$0<3}, iterate: {$0+1}).subscribe(onNext: {
            print($0)
            }).disposed(by: disposeBag)
    }
    
    func practiceMap() {
        let arr = [1, 2, 3,45,56,6,65]

        let _ = arr.filter { $0 < 5 }
        
        let arr2 = [[1, 2, 3],[2,3,4,5],[3,4,5,6,77,8,8,9]]

        let ra = arr2.flatMap {$0}

        let ra2 = ra.filter {$0%2 == 0}
        print(ra2)
        
        let arr3 = [Person(), Person(), Person()]
        _ = arr3.map { (p) -> Person in
            p.addAge()
            return p
        }
    }

}

class Person: NSObject {

    var name: String = "张三"

    var age: Int = 0

    func addAge() {
        age += 5
    }
}

