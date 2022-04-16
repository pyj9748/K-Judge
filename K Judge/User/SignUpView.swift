//
//  SignUpView.swift
//  K Judge
//
//  Created by young june Park on 2022/04/02.
//

import SwiftUI
import Foundation
import Alamofire
import SwiftyJSON

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var signUpViewModel = SignUpViewModel()
    @State var showAlert: Bool = false
    @State var showAlert2: Bool = false

    var body: some View {
        
        VStack{
            KJudgeLogo
            idTextField
            pwdTextField
            pwdCheckTextField
            signUpBtn
        }.padding()
           
    }
}

extension SignUpView {
    //Logo
    var KJudgeLogo : some View {
        Text("K - JUDGE")
            .font(.largeTitle)
            //.bold()
        
    }
    // id text field
    var idTextField : some View {
        TextField("아이디를 입력하세요", text:self.$signUpViewModel.signUp.id)
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
    }
  
    
    // pwd text field
    var pwdTextField : some View {
        SecureField("비밀번호를 입력하세요.", text:self.$signUpViewModel.signUp.password)
            .textFieldStyle(.roundedBorder)
        
      
    }
    
    // pwd text field check
    var pwdCheckTextField : some View {
        SecureField("비밀번호 확인", text:self.$signUpViewModel.signUp.checkPassword)
            .textFieldStyle(.roundedBorder)
        
      
    }
    
    // signup Button
    var signUpBtn : some View {
        Button(action: {
          
            guard self.signUpViewModel.signUp.id != "" || self.signUpViewModel.signUp.password != "" else {
                showAlert = true
                return
            }
            guard self.signUpViewModel.signUp.password.count >= 10 else {
                showAlert = true
                return
            }
            guard self.signUpViewModel.signUp.password == self.signUpViewModel.signUp.checkPassword  else {
                showAlert = true
                return
            }
            
            // api call
            print("singupBtn")
            
            
            let postUser = PostUser(username: signUpViewModel.signUp.id, password: signUpViewModel.signUp.password)

            AF.request("\(baseURL):8080/api/users",
                       method: .post,
                       parameters: postUser,
                       encoder: JSONParameterEncoder.default).response { response in
                debugPrint(response)
            }.responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                   
                    if json["error"]["status"].intValue == 400 {
                        showAlert2 = true
                    }
                    else {
                        presentationMode.wrappedValue.dismiss()
                    }
                 
                default:
                    return
                    
                }

             
            })

           
            
          
            

        }, label: {
            Text("회원가입")
            .frame(width: 340, height: 20, alignment: .center)
        
            .font(.body)
            .padding(10)
            .foregroundColor(.white)
            .background(Color("KWColor3"))
            .cornerRadius(40)
            
        }).alert("회원가입 오류", isPresented: $showAlert) {
            Button("확인"){}
        } message: {
            Text("아이디/패스워드(10글자 이상)를 확인해주세요. 또는 패스워드와 체크 패스워드가 일치해야합니다.")
        }
        .alert("회원가입 오류", isPresented: $showAlert2) {
            Button("확인"){}
        } message: {
            Text("해당 username이 이미 존재합니다.")
        }
        
       
    }
  
    
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
// View Model
class SignUpViewModel :ObservableObject {
  
    @Published var signUp = SignUp(id: "", password: "", checkPassword: "")
    
}



