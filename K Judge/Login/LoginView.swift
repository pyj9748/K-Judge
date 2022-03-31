//
//  LoginView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

//View
struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    @State var idSaveToggle = false
    
    
    
    var body: some View {
        VStack{
            KJudgeLogo
            idTextField
            pwdTextField
            HStack{
                idSaveRadioBox
                loginBtn
            }
            signUpBtn

        }.padding()
    }
}
extension LoginView {
    //Logo
    var KJudgeLogo : some View {
        Text("K - JUDGE")
            .font(.largeTitle)
        
    }
    // id text field
    var idTextField : some View {
        TextField("Enter ID", text:self.$loginViewModel.login.user.id)
            .textFieldStyle(.roundedBorder)
            
        
      
    }
    
    // pwd text field
    var pwdTextField : some View {
        TextField("Enter PWD", text:self.$loginViewModel.login.user.password)
            .textFieldStyle(.roundedBorder)
        
      
    }
    // id save toggle
    var idSaveRadioBox : some View {
        Toggle("아이디 저장", isOn: $idSaveToggle)
            .toggleStyle(.switch)
            
      
    }
    
    // login Button
    var loginBtn : some View {
        Button(action: {
            print("Login")
            //api call
            
        }, label: {
           
                Text("로그인")
                .frame(width: 180, height: 20, alignment: .center)
            
                .font(.body)
                .padding(10)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        })
        
    }
    
    // sign up Button
    var signUpBtn : some View {
        Button(action: {
            print("Sign Up")
            //api call
            
        }, label: {
           
                Text("회원가입")
                .frame(width: 340, height: 20, alignment: .center)
            
                .font(.body)
                .padding(10)
                .foregroundColor(.white)
                .background(Color("Color3"))
                .cornerRadius(40)
        })
        
    }
    
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
