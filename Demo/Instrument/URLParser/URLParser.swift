//
//  URLParser.swift
//  Demo
//
//  Created by WangBo on 2020/5/29.
//  Copyright © 2020 wangbo. All rights reserved.
//

let AliCDNDomain = ".alicdn.com"
let TBCDNDomain = ".tbcdn.cn"
let AliMMDNDomain = ".alimmdn.com"
let COSDOmain = ".cos.ap-shanghai.myqcloud.com"
//https://m3d-storage-dev-1251693531.cos.ap-shanghai.myqcloud.com/11291560758545%2F20190625172755.jpg
let aliCDNSizeFormatMap: [CGFloat] = [100, 200, 800, 1200]

public func parse(for url: URL, imageSize: CGSize?, scale: Int?) -> URL {
    let host = url.host
    if host?.contains(COSDOmain) == true {
        var urlString = url.absoluteString
        var components = [String]()
        components.append("thumbnail")
        if let imageSize = imageSize {
            components.append(String(format: "%dx%d", UInt(imageSize.width), UInt(imageSize.height)))
        }
        if let scale = scale { components.append(String(format: "!%dp", scale)) }

        let cdnConvert = String(format: "?imageMogr2/%@", components.joined(separator: "/"))
        let range = urlString.range(of: "?")
        
        if range == nil {
            urlString.append(cdnConvert)
        } else {
            urlString.insert(contentsOf: cdnConvert, at: range!.lowerBound)
        }
        return URL(string: urlString) ?? url
    } else if host?.contains(AliMMDNDomain) == true {
        var urlString = url.absoluteString
        var components = [String]()
        
        if let scale = scale { components.append(String(format: "%dp", scale)) }
        if let imageSize = imageSize {
            components.append(String(format: "%dh", UInt(imageSize.height)))
            components.append(String(format: "%dw", UInt(imageSize.width)))
            components.append("1e")
        }
        
        let cdnConvert = String(format: "@%@.webp", components.joined(separator: "_"))
        let range = urlString.range(of: "?")
        
        if range == nil {
            urlString.append(cdnConvert)
        } else {
            urlString.insert(contentsOf: cdnConvert, at: range!.lowerBound)
        }
        return URL(string: urlString) ?? url
    } else if host?.contains(AliCDNDomain) == true || host?.contains(TBCDNDomain) == true {
        guard let size = imageSize else {
            return url
        }
        var side = max(size.width, size.height)
        if side > aliCDNSizeFormatMap.last! {
            return url
        }
        
        for format in aliCDNSizeFormatMap {
            if format >= side {
                side = format
                break
            }
        }
        var urlString = url.absoluteString + "_\(UInt(side))x\(UInt(side)).jpg"
        if urlString.range(of: ".webp") != nil {
            urlString.append("_.webp")
        }
        return URL(string: urlString) ?? url
    }
    
    return url
}

