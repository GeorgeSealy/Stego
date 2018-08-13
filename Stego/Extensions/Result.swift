//
//  Result.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case error(NSError)
}
