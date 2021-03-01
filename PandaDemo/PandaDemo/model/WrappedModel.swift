//
//  File.swift
//
//
//  Created by mist on 2021/2/26.
//

import Foundation

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
 }
 */

/*
 请求成功，获取结果为基本类型的数据
 https://run.mocky.io/v3/d1621141-dbbc-4d22-b7eb-17b5fc5101da
 {
  "data": 111,
  "code": 200,
  "msg": "请求成功"
  }
 */

/*
 请求成功，但是不关心data的数据返回内容
 https://run.mocky.io/v3/a4eddd60-e920-4ddf-b193-bc1d68c6e21f
 {
  "data": null,
  "code": 200,
  "msg": "请求成功"
  }
 */

/*
 请求失败的情况
 https://run.mocky.io/v3/adc9a744-b577-4b4b-a903-0a50f3b68400
 {
 "data": null,
 "code": 400,
 "msg": "请求错误"
 }
 */

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
 }
 */

/*
 非正常格式
 */
