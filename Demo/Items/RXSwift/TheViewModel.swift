//
//  TheViewModel.swift
//  Demo
//
//  Created by WangBo on 2020/6/5.
//  Copyright © 2020 wangbo. All rights reserved.
//

import Foundation
import RxSwift

class TheViewModel {
    init() {
    }
    ///当观察者订阅BehaviorSubject时，开始发射最近发射的数据（如果此时还没有收到任何数据，它会发射一个默认值），然后继续发射其它任何来自原始Observable的数据。
    let behaviorSubject = BehaviorSubject<String>(value: "如果前面没有消息，就会发送这个消息")
    
    ///在订阅者订阅之前的消息会丢失
    let publicSubject = PublishSubject<String>()
    
    ///在订阅者订阅之前的1条消息会发送给订阅者
    let asyncSubject = AsyncSubject<String>()
    
    ///在订阅者订阅之前的3条消息会发送给订阅者
    let replaySubject = ReplaySubject<String>.create(bufferSize: 3)
    
    ///作为被观察者时需要 使用asObservable()
    let variableSubject = Variable<String>("aaa")
    
}

