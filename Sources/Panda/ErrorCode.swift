//
//  PandaErrorCode.swift
//
//
//  Created by mist on 2021/2/25.
//

import Foundation

enum PandaErrorCode: Int {
    case converToModelFailed = 9001
    case dataFormatError
    case unowned
    case checkDataValidError

    var description: String {
        switch self {
        case .converToModelFailed:
            return "数据解析错误"
        case .dataFormatError:
            return "数据格式错误"
        case .unowned:
            return "未知错误"
        case .checkDataValidError:
            return "业务处理出错" // 使用业务的message返回
        }
    }
}
