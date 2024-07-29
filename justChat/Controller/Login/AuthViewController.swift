//
//  AuthViewController.swift
//  justChat
//
//  Created by Наталья Атюкова on 07.03.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate!
    var service = Service.shared
    var checkField = CheckField.shared
    var tapGest: UITapGestureRecognizer?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var mainView: UIView!
    
    var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGest = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        mainView.addGestureRecognizer(tapGest!)
    }
    
    @objc func endEditing(){
        self.view.endEditing(true) //Завершает любое ред в родительском View
    }
    
    @IBAction func clickAuthBtn(_ sender: Any) {
        if checkField.validField(emailView, emailField),
           checkField.validField(passwordView, passwordField){
            
            let authData = LoginField(email: emailField.text!, password: passwordField.text!)
            
            service.authInApp(authData) {[weak self] responce in
                switch responce {
                case .succes:
                    self?.userDefault.set(true, forKey: "isLogin")
                    self?.delegate.startApp()
                    self?.delegate.closeVC()
                case .noVerify:
                    let alert = self?.alertAction("Error", "Вы не верифицировали свой имейл. Вам направлена ссылка на электронную почту.")
                    let verifyBtn = UIAlertAction(title: "OK", style: .cancel)
                    alert?.addAction(verifyBtn)
                    self?.present(alert!, animated: true)
                case .error:
                    let alert = self?.alertAction("Error", "Email или пароль указаны не верно")
                    let verifyBtn = UIAlertAction(title: "OK", style: .cancel)
                    alert?.addAction(verifyBtn)
                    self?.present(alert!, animated: true)
                }
            }
        } else {
            let alert = self.alertAction("Error", "Проверьте введеные данные")
            let verefyBtn = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(verefyBtn)
            self.present(alert, animated: true)
        }
    }
    
    func alertAction(_ header: String?, _ message: String) -> UIAlertController{
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        return alert
    }
    
    @IBAction func closeVC(_ sender: Any) {
        delegate.closeVC()
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
    }
    
    @IBAction func newReg(_ sender: Any) {
    }
}
