//
//  NetworConfig.swift
//  3rdDebugger
//
//  Created by TYRAD on 2018/4/12.
//  Copyright © 2018年 chen. All rights reserved.
//

import Alamofire
import Foundation
import Moya

public enum RequestOptionsDefaultGlobal {
    static var needLogger: Bool = true

    static var showLoadingHUD: Bool = false
    static var showFailedHUD: Bool = false
    static var showSuccessHUD: Bool = false

    static var filterSuccessCode: Bool = true // 是否过滤200...299以外的状态码

    static var timeoutIntervalForRequest: TimeInterval = 15
    static var timeoutIntervalForResource: TimeInterval = 60

    static var resultMsgKeyword: String? = "msg"
    static var resultDataKeyword: String? = "data"
    static var resultCodeKeyword: String? = "code"

    static var onSuccess: ((_ options: RequestOptions, _ message: String) -> Void)? // 请求成功，可以在外部进行统一处理，例如添加HUD提示
    static var onFailed: ((_ options: RequestOptions, _ message: String, _ code: Int) -> Void)? // 请求失败，可以在外部进行统一处理，例如添加HUD提示
    static var onLoading: ((_ finished: Bool, _ options: RequestOptions) -> Void)? // 正在请求中的回调

    static var extendInfo: [AnyHashable: Any] = [:] // 根据需求可存放定制化的信息,可以配合`PluginType`使用
    static var plugins: [PluginType] = [] // 自定的扩展
    static var extendErrorCodes: [Int: String] = [:] // 业务额外的错误编码，错误的提示:如果返回了message字段,就用message字段；没有则使用`extendErrorCodes`对应的value值

    /// 处理请求结果,判断是否请求成功
    static var checkResultValid: (([String: Any]) -> (Bool))? = { json in
        if let result = json["code"] as? Int, result == 200 {
            return true
        }
        return false
    }
}

public struct RequestOptions {
    var needLogger: Bool = RequestOptionsDefaultGlobal.needLogger

    var showLoadingHUD: Bool = RequestOptionsDefaultGlobal.showLoadingHUD
    var showFailedHUD: Bool = RequestOptionsDefaultGlobal.showFailedHUD
    var showSuccessHUD: Bool = RequestOptionsDefaultGlobal.showSuccessHUD

    var filterSuccessCode: Bool = RequestOptionsDefaultGlobal.filterSuccessCode

    var timeoutIntervalForRequest: TimeInterval?
    var timeoutIntervalForResource: TimeInterval?

    var resultMsgKeyword: String? = RequestOptionsDefaultGlobal.resultMsgKeyword
    var resultDataKeyword: String? = RequestOptionsDefaultGlobal.resultDataKeyword
    var resultCodeKeyword: String? = RequestOptionsDefaultGlobal.resultCodeKeyword

    var checkResultValid: (([String: Any]) -> (Bool))? = RequestOptionsDefaultGlobal.checkResultValid

    var onSuccess: ((_ options: RequestOptions, _ message: String) -> Void)? = RequestOptionsDefaultGlobal.onSuccess
    var onFailed: ((_ options: RequestOptions, _ message: String, _ code: Int) -> Void)? = RequestOptionsDefaultGlobal.onFailed
    var onLoading: ((_ finished: Bool, _ options: RequestOptions) -> Void)? = RequestOptionsDefaultGlobal.onLoading

    var extendInfo: [AnyHashable: Any] = RequestOptionsDefaultGlobal.extendInfo // 根据需求可存放定制化的信息,可以配合`PluginType`使用
    var plugins: [PluginType] = RequestOptionsDefaultGlobal.plugins // 自定的扩展
    var extendErrorCodes: [Int: String] = RequestOptionsDefaultGlobal.extendErrorCodes // 业务扩展的错误字典

    // 如果想使用直接获取到的json数据,可以用此options
    static var getBarelyResultOptions: RequestOptions {
        var options = RequestOptions()
        options.checkResultValid = nil
        options.resultMsgKeyword = nil
        options.resultDataKeyword = nil
        options.resultCodeKeyword = nil
        return options
    }
}

public class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = RequestOptionsDefaultGlobal.timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = RequestOptionsDefaultGlobal.timeoutIntervalForResource
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
