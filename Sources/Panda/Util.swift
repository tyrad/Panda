//
//  File.swift
//
//
//  Created by mist on 2021/2/25.
//

import Foundation

func DLog<T>(_ message: T,
             file: String = #file,
             method: String = #function,
             line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
