//
//  MoyaPlugin.swift
//  3rdDebugger
//
//  Created by TYRAD on 2018/4/12.
//  Copyright © 2018年 chen. All rights reserved.
//

import Foundation
import Moya
import Result

/// Network activity change notification type.
public enum NetworkActivityChangeType {
    case began, ended
}

/// Notify a request's network activity changes (request begins or ends).
public final class NetworkActivityPlugin: PluginType {
    public typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType) -> Void
    let networkActivityClosure: NetworkActivityClosure

    public init(networkActivityClosure: @escaping NetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }

    /// Called by the provider as soon as the request is about to start
    public func willSend(_: RequestType, target _: TargetType) {
        networkActivityClosure(.began)
    }

    /// Called by the provider as soon as a response arrives, even if the request is canceled.
    public func didReceive(_: Result<Moya.Response, MoyaError>, target _: TargetType) {
        networkActivityClosure(.ended)
    }
}
