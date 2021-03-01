//
//  NetWork.swift
//  3rdDebugger
//
//  Created by TYRAD on 2018/4/12.
//  Copyright © 2018年 chen. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import Result

/// Panda
public struct Panda {
    private static func generateDefaultProvider<T: TargetType>(_ target: T,
                                                               _ needStub: Bool,
                                                               _ options: RequestOptions) -> MoyaProvider<T>
    {
        // endpointClosure
        let endpointClosure = { (target: T) -> Endpoint in
            MoyaProvider<T>.defaultEndpointMapping(for: target)
        }

        // MoyaProvider.immediatelyStub
        let stubClosure = MoyaProvider<T>.immediatelyStub

        // plugin
        var plugins: [PluginType] = options.plugins
        if options.needLogger {
            plugins.append(NetworkLoggerPlugin(verbose: true, cURL: true))
        }
        plugins.append(NetworkActivityPlugin(networkActivityClosure: { type in
            switch type {
            case .began:
                options.onLoading?(true, options)
            case .ended:
                options.onLoading?(false, options)
            }
        })
        )

        let sm = DefaultAlamofireManager.sharedManager
        if let timeoutIntervalForRequest = options.timeoutIntervalForRequest {
            sm.session.configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        }
        if let timeoutIntervalForResource = options.timeoutIntervalForResource {
            sm.session.configuration.timeoutIntervalForResource = timeoutIntervalForResource
        }
        if needStub == false {
            return MoyaProvider<T>(
                endpointClosure: endpointClosure,
                manager: DefaultAlamofireManager.sharedManager,
                plugins: plugins
            )
        } else {
            return MoyaProvider<T>(
                endpointClosure: endpointClosure,
                stubClosure: stubClosure,
                manager: DefaultAlamofireManager.sharedManager,
                plugins: plugins
            )
        }
    }

    /// 请求Mappable模型数据[接口返回JSON格式数据]
    @discardableResult
    public static func requestModel<T: Mappable, R: TargetType>(
        type: R,
        options: RequestOptions = RequestOptions(),
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping ((T, _ msg: String) -> Void),
        failure: @escaping ((String, _ errorCode: Int) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub, options)
        return provider.request(type, progress: progress, completion: { result in
            handleCompletion(result: result,
                             options: options) { msg, code in
                failure(msg, code)
                options.onFailed?(options, msg, code)
            } modelCmd: { data, msg in
                if let model: T = PandaModelTool.objectFromJSON(data) {
                    success(model, msg)
                    options.onSuccess?(options, msg)
                } else {
                    let msg = PandaErrorCode.converToModelFailed.description
                    let code = PandaErrorCode.converToModelFailed.rawValue
                    failure(msg, code)
                    options.onFailed?(options, msg, code)
                }
            }
        })
    }

    /// 请求的data是简单的类型,例如 int string 等等 [接口返回JSON格式数据]
    @discardableResult
    public static func requestSimpleType<T, R: TargetType>(
        type: R,
        options: RequestOptions = RequestOptions(),
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping ((T, _ msg: String) -> Void),
        failure: @escaping ((String, _ errorCode: Int) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub, options)
        return provider.request(type, progress: progress, completion: { result in
            handleCompletion(result: result,
                             options: options) { msg, code in
                failure(msg, code)
                options.onFailed?(options, msg, code)
            } modelCmd: { data, msg in
                if let model = data as? T {
                    success(model, msg)
                    options.onSuccess?(options, msg)
                } else {
                    let msg = PandaErrorCode.converToModelFailed.description
                    let code = PandaErrorCode.converToModelFailed.rawValue
                    failure(msg, code)
                    options.onFailed?(options, msg, code)
                }
            }
        })
    }

    /// 请求模型数组 [接口返回JSON格式数据]
    @discardableResult
    public static func requestModelList<T: Mappable, R: TargetType>(
        type: R,
        options: RequestOptions = RequestOptions(),
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping (([T], _ msg: String) -> Void),
        failure: @escaping ((String, _ statusCode: Int) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub, options)
        return provider.request(type, progress: progress, completion: { result in
            handleCompletion(result: result,
                             options: options) { msg, code in
                failure(msg, code)
                options.onFailed?(options, msg, code)
            } modelCmd: { data, msg in
                if let models: [T] = PandaModelTool.listFromJSON(data) {
                    success(models, msg)
                    options.onSuccess?(options, msg)
                } else {
                    let msg = PandaErrorCode.converToModelFailed.description
                    let code = PandaErrorCode.converToModelFailed.rawValue
                    failure(msg, code)
                    options.onFailed?(options, msg, code)
                }
            }
        })
    }

    /// 不关心data返回，验证请求成功即可 [接口返回JSON格式数据]
    @discardableResult
    public static func requestCheckSuccess<R: TargetType>(
        type: R,
        options: RequestOptions = RequestOptions(),
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping ((_ msg: String) -> Void),
        failure: @escaping ((String, _ statusCode: Int) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub, options)
        return provider.request(type, progress: progress, completion: { result in

            handleCompletion(result: result,
                             options: options) { msg, code in
                failure(msg, code)
                options.onFailed?(options, msg, code)
            } modelCmd: { _, msg in
                success(msg)
                options.onSuccess?(options, msg)
            }
        })
    }

    /// 将请求获取的Data数据原样返回，不验证请求返回的格式
    @discardableResult
    public static func requestData<R: TargetType>(
        type: R,
        options: RequestOptions = RequestOptions(),
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping ((_: Data) -> Void),
        failure: @escaping ((String, _ statusCode: Int) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub, options)
        return provider.request(type, progress: progress, completion: { result in
            handleDataCompletion(result: result, options: options) { msg, code in
                failure(msg, code)
                options.onFailed?(options, msg, code)
            } modelCmd: { data in
                success(data)
                options.onSuccess?(options, "")
            }
        })
    }

    private static func handleDataCompletion(
        result: Result<Moya.Response, MoyaError>,
        options: RequestOptions,
        failure: @escaping ((String, _ statusCode: Int) -> Void),
        modelCmd: (_ data: Data) -> Void
    ) {
        switch result {
        case let .success(response):
            modelCmd(response.data)
        case let .failure(error):
            failure(error.errorDescription ?? "", (error as NSError).code)
        }
    }

    private static func handleCompletion(
        result: Result<Moya.Response, MoyaError>,
        options: RequestOptions,
        failure: @escaping ((String, _ errorCode: Int) -> Void),
        modelCmd: (_ data: Any?, _ message: String) -> Void
    ) {
        switch result {
        case let .success(response):
            var json: Any!
            do {
                if options.filterSuccessCode {
                    _ = try response.filterSuccessfulStatusCodes()
                }
                json = try response.mapJSON()
            } catch {
                let (msg, _) = handelError(error: error)
                // 以状态码作为errorCode
                failure(msg, response.statusCode)
                return
            }
            guard let jsonObject = json as? [String: Any] else {
                failure(PandaErrorCode.dataFormatError.description, PandaErrorCode.dataFormatError.rawValue)
                return
            }
            let (message, code, data) = handleResult(jsonObject: jsonObject, options: options)
            guard let checkResultValid = options.checkResultValid else {
                modelCmd(data, message ?? "")
                return
            }
            let isValid = checkResultValid(jsonObject)
            if isValid {
                modelCmd(data, message ?? "")
            } else {
                failure(message ?? PandaErrorCode.checkDataValidError.description,
                        code ?? PandaErrorCode.checkDataValidError.rawValue)
            }
        case let .failure(error):
            failure(error.errorDescription ?? "", (error as NSError).code)
        }
    }

    private static func handleResult(jsonObject: [String: Any], options: RequestOptions) -> (message: String?, code: Int?, data: Any?) {
        var code: Int?
        if let codeKey = options.resultCodeKeyword {
            code = jsonObject[codeKey] as? Int
        }
        var message: String?
        if let msgKey = options.resultMsgKeyword {
            message = jsonObject[msgKey] as? String ?? ""
        }
        if let code = code,
           message == nil || message == "",
           let errMsg = options.extendErrorCodes[code]
        {
            message = errMsg
        }
        var data: Any? = jsonObject // 默认如果没有指定dataKey,则处理请求到的json数据
        if let dataKey = options.resultDataKeyword {
            data = jsonObject[dataKey]
        }
        return (message: message, code: code, data: data)
    }

    private static func handelError(error: Error) -> (String, Int) {
        if let error = error as? MoyaError {
            return (Panda.mapErrorString(error: error), error.errorCode)
        } else {
            return (PandaErrorCode.unowned.description, PandaErrorCode.unowned.rawValue)
        }
    }

    static func mapErrorString(error: MoyaError) -> String {
        /*
         switch error {
         case .imageMapping:
             return "图片解析失败"
         case .jsonMapping:
             return "json解析失败"
         case .stringMapping:
             return "字符串解析失败"
         case .objectMapping:
             return "Decodable Error"
         case .encodableMapping:
             return "Encodable Error"
         case let .statusCode(response):
             return "请求失败 statusCode:\(response.statusCode)"
         case .underlying:
             return "Failed to map Endpoint to a URLRequest."
         case .requestMapping:
             return "Failed to encode parameters for URLRequest."
         case .parameterEncoding:
             return error.localizedDescription
         }
         */
        return error.localizedDescription
    }
}
