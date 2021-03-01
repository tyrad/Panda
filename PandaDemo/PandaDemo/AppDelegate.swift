//
//  AppDelegate.swift
//  PandaDemo
//
//  Created by mist on 2021/3/1.
//

import Panda
import PKHUD
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 全局配置
        RequestOptionsDefaultGlobal.resultMsgKeyword = "msg"
        RequestOptionsDefaultGlobal.resultDataKeyword = "data"
        RequestOptionsDefaultGlobal.resultCodeKeyword = "code"

        RequestOptionsDefaultGlobal.showLoadingHUD = true
        RequestOptionsDefaultGlobal.showSuccessHUD = true
        RequestOptionsDefaultGlobal.showFailedHUD = true

        RequestOptionsDefaultGlobal.plugins = [AuthorizationPlugin()]

        RequestOptionsDefaultGlobal.onLoading = { loading, option in
            if option.showLoadingHUD {
                print(loading ? "请求开始loading" : "请求结束endloading")
                if loading {
                    HUD.show(HUDContentType.progress)
                } else {
                    HUD.hide()
                }
            }
        }

        RequestOptionsDefaultGlobal.onSuccess = { option, message in
            if option.showSuccessHUD {
                print("请求成功:", message)
                HUD.flash(.success, delay: 1.0)
            }
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
