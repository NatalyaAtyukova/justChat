//
//  RegViewController.swift
//  justChat
//
//  Created by Наталья Атюкова on 07.03.2023.
//

import UIKit
import FirebaseStorage


class RegViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var delegate: LoginViewControllerDelegate!
    var checkField = CheckField.shared
    var service = Service.shared
    var tapGest: UITapGestureRecognizer? //Жест для тапа по экрану пальцем
    var urlString = ""
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var rePasswordField: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var repasswordView: UIView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var photoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGest = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        mainView.addGestureRecognizer(tapGest!)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeVC(_ sender: Any) {
        delegate.closeVC()
    }
    
    @objc func endEditing(){
        self.view.endEditing(true) //Завершает любое ред в родительском View
    }
    
    @IBAction func regBtnClick(_ sender: Any) {
        if checkField.validField(emailView, emailField), (checkField.validField(passwordView, passwordField)) {
            if passwordField.text == rePasswordField.text {
                service.createNewUser(LoginField(email: emailField.text!, password: passwordField.text!)) { [weak self] code in
                    switch code.code{
                    case 0:
                        print("Произошла ошибка регистрации")
                    case 1:
                        self?.service.confirmEmail()
                        
                        let alert = UIAlertController(title: "OK", message: "Success", preferredStyle: .alert) //alert - всплывающее окно (исп. при успешной регистрации)
                        let okBtn = UIAlertAction(title: "Auth", style: .default) { _ in
                            self?.delegate.closeVC()
                        }
                        alert.addAction(okBtn)
                        self?.present(alert, animated: true)
                    default:
                        print("Неизвестная ошибка")
                    }
                }
            } else {
                print("Пароли не совпадают")
            }
            
        }
    }
    
    
    @IBAction func photoButtomPressed(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoImageView.image = image
    }

    
    //Конвертация и выгрузка в ФБ
//    func upload(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
//        let ref = Storage.storage().reference().child("avatars").child(currentUserId)
//
//        guard let imageData = photoImageView.image?.jpegData(compressionQuality: 0.4) else { return }
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        ref.putData(imageData, metadata: metadata) { (metadata, error) in
//            guard let _ = metadata else {
//                completion(.failure(error!))
//                return
//            }
//            ref.downloadURL { (url, error) in
//                guard let url = url else {
//                    completion(.failure(error!))
//                    return
//                }
//                completion(.success(url))
//            }
//        }
//    }
//
    
}
   
