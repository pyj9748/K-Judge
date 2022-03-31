//
//  LoginViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import Foundation

// View Model
class LoginViewModel :ObservableObject {
  
    @Published var login = Login(user: User(id: "", password: ""))
    
}
