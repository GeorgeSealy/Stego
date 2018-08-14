//
//  Log.swift
//  Stego
//
//  Created by George Sealy on 14/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

public func Log(_ object: @autoclosure () -> Any) {
    
    #if DEBUG
    
    var val = object()
    
    if let str = val as? String, let safeStr = (str as NSString).removingPercentEncoding {
        val = safeStr
    }
    
    NSLog("[\(Thread.isMainThread ? "UI" : "BG")] \(val)")// swiftlint:disable:this custom_rules
    
    #endif
    
}
