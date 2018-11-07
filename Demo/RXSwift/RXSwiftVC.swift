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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        empty()
        just()
        of()
        from()
        creat()
        //range()
        //repeatElement()
        genreate()
    }
    
    func never(){
        let disposeBag = DisposeBag()
        let neverSequence = Observable<String>.never()
        _ = neverSequence.subscribe{_ in
            print("This iwill never be printed")
            }.disposed(by: disposeBag)
        
    }
    
    func empty() {
        let disposeBag = DisposeBag()
        Observable<Int>.empty().subscribe{ event in
            print(event)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
            }.disposed(by: disposeBag)
    }
    
    func just() {
        let disposeBag = DisposeBag()
        Observable.just("aaaa").subscribe{event in
            print(event)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
            }.disposed(by: disposeBag)
    }
    
    func of()  {
        let bag = DisposeBag()
        Observable.of(1,2,3,4,5).subscribe({event in
            print(event)
        }).disposed(by: bag)
        
        Observable.of(1,2,3,4,5).subscribe(onNext: { (a) in
            print(a)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: bag)
    }
    
    func from() {
        let bag = DisposeBag()
        Observable.from([1,2,3,4,5,6]).subscribe(onNext: { (a) in
            print(a)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
    }
    
    func creat() {
        let bag = DisposeBag()
        let se = Observable<Any>.create { (observer) -> Disposable in
            observer.on(.next("1234"))
            observer.on(.completed)
            return Disposables.create()
        }
        se.subscribe({
            print($0)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: bag)
        
    }
    
    func range() {
        let bag = DisposeBag()
        Observable.range(start: 1, count: 10).subscribe({
            print($0)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: bag)
        
        Observable.range(start: 1, count: 10).subscribe(onNext: { (a) in
            print(a)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: bag)
    }
    
    func repeatElement() {
        let bag = DisposeBag()
        Observable.repeatElement("6").take(6).subscribe(onNext: {
            print($0)
            print("↑↑↑↑↑↑↑↑↑-------------\(#function)------------↑↑↑↑↑↑↑↑↑↑\r")
        }).disposed(by: bag)
    }
    
    func genreate() {
        let bag = DisposeBag()
        Observable.generate(initialState: 0, condition:{$0<3}, iterate:{$0+1}).subscribe(onNext:{
            print($0)
            }).disposed(by: bag)
    }
    
    func publishSubject() {
        let bag = DisposeBag()
        var subject = PublishSubject<String>()
    }
    
}



