//
//  ViewController.swift
//  PandaDemo
//
//  Created by mist on 2021/3/1.
//

import Panda
import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonClick(_ sender: Any) {
        Panda.requestModel(type: API.getNormalModel) { (_: BarelyModel, _) in
        } failure: { _, _ in
        }
    }
}
