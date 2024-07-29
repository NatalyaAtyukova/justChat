//
//  Model.swift
//  justChat
//
//  Created by Наталья Атюкова on 03.03.2023.
//

import UIKit
import Foundation

enum AuthResponce{
    case succes, noVerify, error
}

struct Slides{
    var id: Int
    var text: String
    var img: UIImage
}

struct LoginField{
    var email: String
    var password: String
}

struct ResponseCode { // Cтруктура для проверки ошибок 
    var code: Int
}

struct CurrentUsers {
    var id: String
    var email: String
}




