//
//  Login.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import Foundation

// Model

struct User :Encodable{
    var id : String
    var password : String
    var token : String
}


struct Login : Encodable {
    
    var user : User
    
    
}
struct SignUp : Encodable {
    
    var id : String
    var password : String
    var checkPassword : String
    
    
}
