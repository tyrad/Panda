@testable import Panda
import XCTest

final class PandaTests: XCTestCase {
    static var allTests = [
        ("testGetNormalModel", testGetNormalModel),
        ("testSimpleData", testSimpleData),
        ("testGetBarelyData", testGetBarelyData),
        ("testModelList", testModelList),
        ("testModelListEmpty", testModelListEmpty),
        ("testEmptyData", testEmptyData),
        ("testFailedData", testFailedData),
        ("testHtmlText", testHtmlText),
        ("testUserErrorCode", testUserErrorCode)
    ]

    func testGetNormalModel() {
        // {
        //    "data":{
        //        "foo":"1",
        //        "bar":"2"
        //    },
        //    "code":200,
        //    "msg":"成功"
        // }

        // RequestOptionsDefaultGlobal.resultDataKeyword = "result"

        let messageException = self.expectation(description: #function)
        Panda.requestModel(type: API.getNormalModel) { (model: BarelyModel, _) in
            messageException.fulfill()
            XCTAssertEqual(model.bar, "2")
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testSimpleData() {
        /*
         请求成功，获取结果为基本类型的数据
         https://run.mocky.io/v3/d1621141-dbbc-4d22-b7eb-17b5fc5101da
         {
          "data": 111,
          "code": 200,
          "msg": "请求成功"
          }

         测试下 [Int]
         */
        let messageException = self.expectation(description: #function)
        Panda.requestSimpleType(type: API.getSimpleData) { (result: Int, _) in
            messageException.fulfill()
            XCTAssertEqual(result, 111)
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testGetBarelyData() {
        /*
         curl https://run.mocky.io/v3/09b6441a-6615-42af-a6ba-a141b6a5b1fa
         {
         "foo":"1",
         "bar":"2"
         }*/
        let messageException = self.expectation(description: #function)

        let options = RequestOptions.getBarelyResultOptions
        Panda.requestModel(type: API.getBarelyModel, options: options) { (model: BarelyModel, _) in
            messageException.fulfill()
            XCTAssertEqual(model.foo, "1")
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testModelList() {
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
        let messageException = self.expectation(description: #function)
        Panda.requestModelList(type: API.getListData) { (models: [BarelyModel], _) in
            XCTAssertEqual(models[2].foo, "12")
            messageException.fulfill()
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testModelListEmpty() {
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
        let messageException = self.expectation(description: #function)
        Panda.requestModelList(type: API.getListEmptyData) { (models: [BarelyModel], _) in
            XCTAssertEqual(models.count, 0)
            messageException.fulfill()
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testEmptyData() {
        /*
         请求成功，但是不关心data的数据返回内容
         https://run.mocky.io/v3/a4eddd60-e920-4ddf-b193-bc1d68c6e21f
         {
          "data": null,
          "code": 200,
          "msg": "请求成功"
          }
         */
        let messageException = self.expectation(description: #function)
        Panda.requestCheckSuccess(type: API.getEmptyData) { msg in
            XCTAssertEqual(msg, "请求成功")
            messageException.fulfill()
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testFailedData() {
        /*
         请求失败的情况
         https://run.mocky.io/v3/adc9a744-b577-4b4b-a903-0a50f3b68400
         {
         "data": null,
         "code": 400,
         "msg": "请求错误"
         }
         */
        let messageException = self.expectation(description: #function)
        Panda.requestCheckSuccess(type: API.failedDemo) { _ in
            XCTFail("\(#function)失败")
        } failure: { msg, code in
            print(msg)
            XCTAssertEqual(code, 400)
            messageException.fulfill()
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testHtmlText() {
        let messageException = self.expectation(description: #function)

        Panda.requestData(type: API.htmlText) { (result: Data) in
            dump(String(data: result, encoding: .utf8))
            XCTAssertEqual(1, 1)
            messageException.fulfill()
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }

        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testRequetWithLoading() {
        // {
        //    "data":{
        //        "foo":"1",
        //        "bar":"2"
        //    },
        //    "code":200,
        //    "msg":"成功"
        // }

        RequestOptionsDefaultGlobal.showLoadingHUD = true
        RequestOptionsDefaultGlobal.showSuccessHUD = true
        RequestOptionsDefaultGlobal.showFailedHUD = true

        RequestOptionsDefaultGlobal.onLoading = { loading, option in
            if option.showLoadingHUD {
                print(loading ? "请求开始loading" : "请求结束endloading")
            }
        }

        RequestOptionsDefaultGlobal.onSuccess = { option, message in
            if option.showSuccessHUD {
                print("请求成功", option, message)
                // HUD.showSuccess()
            }
        }

        RequestOptionsDefaultGlobal.onFailed = { option, message, code in
            if option.showFailedHUD {
                print("请求失败", option, message, code)
                // HUD.showError()
            }
            // 可根据code处理登录过期等业务代码
        }

        let messageException = self.expectation(description: #function)
        Panda.requestModel(type: API.getNormalModel) { (model: BarelyModel, _) in
            messageException.fulfill()
            XCTAssertEqual(model.bar, "2")
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testUserErrorCode() {
        /*
         请求失败的情况
         {
         "data": null,
         "code": 1400,
         "msg": ""
         }
         */

        // 自定义状态码, 如果msg为空，使用状态码对应的text
        RequestOptionsDefaultGlobal.extendErrorCodes = [1400: "登录失效"]

        let messageException = self.expectation(description: #function)
        Panda.requestCheckSuccess(type: API.testErrorCode) { _ in
            XCTFail("\(#function)失败")
        } failure: { msg, _ in
            print(msg)
            XCTAssertEqual(msg, "登录失效")
            messageException.fulfill()
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }

    func testAddToken() {
        // {
        //    "data":{
        //        "foo":"1",
        //        "bar":"2"
        //    },
        //    "code":200,
        //    "msg":"成功"
        // }
        RequestOptionsDefaultGlobal.plugins = [AuthorizationPlugin()]
        let messageException = self.expectation(description: #function)
        Panda.requestModel(type: API.getNormalModel) { (model: BarelyModel, _) in
            messageException.fulfill()
            XCTAssertEqual(model.bar, "2")
        } failure: { msg, code in
            XCTFail("\(#function)失败, code=\(code), msg=\(msg)")
        }
        self.waitForExpectations(timeout: 10) { _ in
        }
    }
}
