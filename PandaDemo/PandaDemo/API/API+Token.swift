//
//  File.swift
//
//
//  Created by mist on 2021/2/28.
//

import Foundation
import Moya

protocol AuthorizedTargetType: TargetType {
    // 给moya枚举使用,表示哪些请求需要token
    var needsAuth: Bool { get }
}

struct AuthorizationPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? AuthorizedTargetType,
              target.needsAuth
        else {
            return request
        }
        var request = request
        request.addValue("123", forHTTPHeaderField: "token")
        return request
    }
}
