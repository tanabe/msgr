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
        if let email = Defaults[.email], let password = Defaults[.password] {
            hideLoginUI()
            login(email: email, password: password)
        } else {
            showLoginUI()
        }
    }

    func bind() {
        loginButton.rx.tap.asObservable().bind { [weak self] in
            let email = self?.emailTextField.text ?? ""
            let password = self?.passwordTextField.text ?? ""
            self?.showLoading()
            self?.login(email: email, password: password)
        }.disposed(by: disposeBag)
        // TODO reactive
        // this code may not hide loading
    }

    func showLoading() {
        HUD.show(.progress)
    }

    func hideLoading() {
        HUD.hide()
    }

    func hideLoginUI() {
        loginView.isHidden = true
    }

    func showLoginUI() {
        loginView.isHidden = false
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                log.debug("login successful")
                Defaults[.email] = email
                Defaults[.password] = password
                let fcmToken = Messaging.messaging().fcmToken ?? ""
                log.debug("FCM token is: \(fcmToken)")
                if let user = result?.user {
                    self.updateUser(userId: user.uid, fcmToken: fcmToken)
                }
                self.gotoMessageView()
            } else {
                log.debug("login failure")
                Defaults.remove(.email)
                Defaults.remove(.password)
            }
        }
    }
    
    func updateUser(userId: String, fcmToken: String) {
        let db = Firestore.firestore()
        let user: [String: Any] = [
            "name": "todo",
            "fcmToken": fcmToken
        ]
        db.collection("users").document(userId).setData(user) { (error) in
            if let error = error {
                log.error(error)
            } else {
                log.debug("success")
            }
        }
    }

    func gotoMessageView() {
        let messageNavigationViewController = R.storyboard.message.instantiateInitialViewController()
        AppDelegate.shared.window?.rootViewController = messageNavigationViewController
    }
}
