//
//  File.swift
//
//
//  Created by mist on 2021/2/26.
//

import Foundation
import ObjectMapper

struct BarelyModel: Mappable {
    var foo: String?
    var bar: String?
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        foo <- map["foo"]
        bar <- map["bar"]
    }
}

// curl https://run.mocky.io/v3/09b6441a-6615-42af-a6ba-a141b6a5b1fa
// {
// "foo":"1",
// "bar":"2"
// }
