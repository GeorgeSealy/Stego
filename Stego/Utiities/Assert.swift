//
//  Assert.swift
//  Stego
//
//  Created by George Sealy on 14/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

public func ERROR(_ message: String, info: [String: Any]? = nil) {
    
    var errorMsg = "ERROR" + " : " + message
    
    var stackTrace = ""
    
    stackTrace += "\n  Thread: \(String(describing: Thread.current.name))"
    
    for symbol in Thread.callStackSymbols {
        stackTrace += "\n    - \(symbol)"
    }
    
    errorMsg += " : " + stackTrace
    
    Log("ERROR: \(errorMsg)")
}

public func SHOULDNT_GET_HERE(_ message: String, file: String = #file, method: String = #function, line: Int = #line) {
    
    var finalMessage: String = "SHOULDN'T GET HERE"
    
    let fileURL = URL(string: file)?.lastPathComponent
    
    let locationInfo = "\(fileURL ?? "")_\(method)_\(line)"
    
    finalMessage += ": \(locationInfo)\n"
    finalMessage += ": \(message)\n"
    
    ERROR(finalMessage)
    
}

public func ASSERT_MAIN_THREAD(_ msg: String? = nil) {
    
    if !Thread.isMainThread {
        ERROR("ASSERT_MAIN_THREAD")
    }
    
}

public func ASSERT(_ condition: Bool, _ message: String? = nil) {
    if !condition {
        if let msg = message {
            SHOULDNT_GET_HERE("Assert Failed: \(msg)")
        } else {
            SHOULDNT_GET_HERE("Assert Failed (but no message)")
        }
    }
}
