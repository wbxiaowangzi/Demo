//
//  SwiftUIView.swift
//  Demo
//
//  Created by WangBo on 2019/10/22.
//  Copyright © 2019 wangbo. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    @available(iOS 13.0.0, *)
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
        
    }
}

struct LandmarkList: View {
    @available(iOS 13.0.0, *)
    var body: some View {
        List(0..<5) { item in
            Text("helo")
                .font(.title)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        //SwiftUIView()
        LandmarkList()
    }
}
