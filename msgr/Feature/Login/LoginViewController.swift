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
import PKHUD
import RxSwift
import RxCocoa
import SwiftyUserDefaults
import UIKit

extension DefaultsKeys {
    static let email = DefaultsKey<String?>("email")
    static let password = DefaultsKey<String?>("password")
}

class LoginViewController: UIViewController {

    let disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseApp.configure()

        bind()
    }

    func bind() {
        loginButton.rx.tap.asObservable().bind { [weak self] in
            let email = self?.emailTextField.text ?? ""
            let password = self?.passwordTextField.text ?? ""
            self?.login(email: email, password: password)
        }.disposed(by: disposeBag)
    }

    func hideLoginUI() {
        HUD.show(.progress)
        loginView.isHidden = true
    }

    func showLoginUI() {
        HUD.hide()
        loginView.isHidden = false
    }

    func login(email: String, password: String) {
        hideLoginUI()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                log.debug("login successful")
                let fcmToken = Messaging.messaging().fcmToken
                log.debug("FCM token is: \(fcmToken ?? "")")
            } else {
                log.debug("login failure")
            }
        }
    }
    
    func gotoMessageView() {
        //let messageNavigationViewController = R.storyboard.message.instantiateInitialViewController()
        //AppDelegate.shared.window?.rootViewController = messageNavigationViewController
    }
}
