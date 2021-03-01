//
//  Model.swift
//  3rdDebugger
//
//  Created by TYRAD on 2018/4/12.
//  Copyright © 2018年 chen. All rights reserved.
//

import Foundation
import ObjectMapper

enum PandaModelTool {
    // Object类型数据转换
    static func objectFromJSON<T: Mappable>(_ jsonObject: Any?) -> T? {
        let mapperModel = Mapper<T>()
        return mapperModel.map(JSONObject: jsonObject)
    }

    // Object List 类型数据转换
    static func listFromJSON<T: Mappable>(_ jsonObject: Any?) -> [T]? {
        let mapperModel = Mapper<T>()
        return mapperModel.mapArray(JSONObject: jsonObject)
    }
}
