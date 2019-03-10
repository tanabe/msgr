//
//  LoginViewController.swift
//  msgr
//
//  Created by hideaki_tanabe on 2019/03/09.
//  Copyright © 2019年 Hideaki Tanabe. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseMessaging
import RxSwift
import RxCocoa
import SwiftyUserDefaults
import UIKit

class LoginViewController: UIViewController {

    let disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseApp.configure()
        bind()
    }

    func bind() {
    }

    func login(email: String, password: String) {
    }
}
