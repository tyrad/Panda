//
//  API.swift
//  NanningIndustry
//
//  Created by TYRAD on 2018/4/18.
//  Copyright © 2018年 quicktouch. All rights reserved.
//

import Foundation
import Moya

enum API {
    /*
     最常见的请求成功
     https://run.mocky.io/v3/892227d7-f6b2-4a83-9ecf-82d1f8a5d7a9
     {
         "data":{
             "foo":"1",
             "bar":"2"
         },
         "code":200,
         "msg":"成功"
     }*/
    case getNormalModel

    /*
     请求成功，获取结果为基本类型的数据
     https://run.mocky.io/v3/d1621141-dbbc-4d22-b7eb-17b5fc5101da
     {
      "data": 111,
      "code": 200,
      "msg": "请求成功"
      }
     */
    case getSimpleData

    /*
     请求成功，但是不关心data的数据返回内容
     https://run.mocky.io/v3/a4eddd60-e920-4ddf-b193-bc1d68c6e21f
     {
      "data": null,
      "code": 200,
      "msg": "请求成功"
      }
     */
    case getEmptyData

    /*
     请求失败的情况
     https://run.mocky.io/v3/adc9a744-b577-4b4b-a903-0a50f3b68400
     {
     "data": null,
     "code": 400,
     "msg": "请求错误"
     }
     */
    case failedDemo

    /*
     嵌套数据为数组格式
     https://run.mocky.io/v3/bdd591fe-4771-4a1b-ab0b-d36f0e5119f8
     {
     "data": [
         {
         "foo":"1",
         "bar":"2"
         },
         {
         "foo":"11",
         "bar":"22"
         },{
         "foo":"12",
         "bar":"23"
         }
      ],
     "code": 200,
     "msg": "请求成功"
     }*/
    case getListData

    /*
     嵌套类型为空数组
     https://run.mocky.io/v3/dc93f951-bf89-45fb-9216-2000547f1239
     {
      "data": [
       ],
      "code": 200,
      "msg": "请求成功"
      }
     */
    case getListEmptyData

    /*
     curl https://run.mocky.io/v3/09b6441a-6615-42af-a6ba-a141b6a5b1fa
     {
     "foo":"1",
     "bar":"2"
     }*/
    case getBarelyModel

    /*
     https://baidu.com
     */
    case htmlText

    /**
     {
     "data": null,
     "code": 1400,
     "msg": ""
     }
     */
    case testErrorCode

    // 非正常数据，例如不是data 而是result的情况。
    // 全局处理的举例。
}

extension API: TargetType, AuthorizedTargetType {
    var baseURL: URL {
        switch self {
        case .htmlText:
            return URL(string: "https://www.baidu.com/")!
        default:
            return URL(string: "https://run.mocky.io/v3")!
        }
    }

    var path: String {
        switch self {
        case .getBarelyModel:
            return "/09b6441a-6615-42af-a6ba-a141b6a5b1fa"
        case .getNormalModel:
            return "/892227d7-f6b2-4a83-9ecf-82d1f8a5d7a9"
        case .getSimpleData:
            return "/d1621141-dbbc-4d22-b7eb-17b5fc5101da"
        case .getEmptyData:
            return "/a4eddd60-e920-4ddf-b193-bc1d68c6e21f"
        case .failedDemo:
            return "/adc9a744-b577-4b4b-a903-0a50f3b68400"
        case .getListData:
            return "/bdd591fe-4771-4a1b-ab0b-d36f0e5119f8"
        case .getListEmptyData:
            return "/dc93f951-bf89-45fb-9216-2000547f1239"
        case .htmlText:
            return ""
        case .testErrorCode:
            return "/0d106601-38b1-4796-808b-b4ac82d4ce98"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestParameters(parameters: [:], encoding: URLEncoding.default)
    }

    var headers: [String: String]? {
        return nil
    }

    var needsAuth: Bool {
        return true
    }

    var sampleData: Data {
        return "no sample data.".utf8Encoded
    }
}

// MARK: - Helpers

private func readFileData(name: String, ext: String) -> Data? {
    if let path = Bundle.main.path(forResource: name, ofType: ext),
       let data = NSData(contentsOf: URL(fileURLWithPath: path))
    {
        return data as Data
    }
    return nil
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

private func jsonToData(jsonDic: [String: Any]) -> Data? {
    if !JSONSerialization.isValidJSONObject(jsonDic) {
        print("is not a valid json object")
        return nil
    }
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
    let str = String(data: data!, encoding: String.Encoding.utf8)
    print("Json Str:\(str!)")
    return data
}
