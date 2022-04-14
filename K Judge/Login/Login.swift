//
//  Login.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import Foundation
import SwiftyJSON
import Alamofire
// Model

struct User :Encodable{
    var id : String
    var password : String
    var token : String
    
    
}

func renewToken( id : String ,  password: String ,  closure : @escaping ()->() ) -> String{
    var token : String = ""
    
    let postUser = PostUser(username:id, password: password)

    AF.request("\(baseURL):8080/api/users/login",
               method: .post,
               parameters: postUser,
               encoder: JSONParameterEncoder.default).response { response in
        debugPrint(response)
    }.responseJSON(completionHandler: {
        response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            token = json["data"]["token"].stringValue
            print("renew Token : \(token)")
            
            return
        default:
            return
        }
    })
    closure()
    return token
}

struct Login : Encodable {
    
    var user : User
    
    
}
struct SignUp : Encodable {
    
    var id : String
    var password : String
    var checkPassword : String
    
    
}
