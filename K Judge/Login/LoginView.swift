//
//  LoginView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI
import Foundation
import Alamofire
import SwiftyJSON

//View
struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    @State var canLogin : Bool = false
    @State var showAlert: Bool = false
    @State var shouldNavigate = false
    @AppStorage("isLoggedIn") var isLoggendIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @AppStorage("idSaveToggle") var idSaveToggle: Bool = UserDefaults.standard.bool(forKey: "idSaveToggle")
    @AppStorage("id") var id: String = (UserDefaults.standard.string(forKey: "id") ?? "")
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    
    var body: some View {
        NavigationView{
            VStack{
                KJudgeLogo
                if idSaveToggle == false {
                    idTextField
                } else{
                    savedIdTextField
                }
                pwdTextField
                HStack{
                    idSaveRadioBox
                    loginBtn
                }
                signUpBtn
                    
            }.padding()
            .navigationBarHidden(true)
        }
        
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
        TextField("아이디룰 입력하세요.", text:self.$loginViewModel.login.user.id)
            .textFieldStyle(.roundedBorder)
    }
    // saved id text Field
    var savedIdTextField : some View{
      
        TextField(self.id, text:self.$id)
            .textFieldStyle(.roundedBorder)
    }
    
    // pwd text field
    var pwdTextField : some View {
        SecureField("비밀번호를 입력하세요.", text:self.$loginViewModel.login.user.password)
            .textFieldStyle(.roundedBorder)
        
      
    }
    // id save toggle
    var idSaveRadioBox : some View {
        Toggle("아이디 저장", isOn: $idSaveToggle)
            .toggleStyle(.switch)
            
      
    }
    
    // login Button
    var loginBtn : some View {
        
        NavigationLink(destination: MainView(), isActive: $shouldNavigate,label: {
            Button(action: {
                guard self.loginViewModel.login.user.id != "" || self.loginViewModel.login.user.password != "" else {
                    showAlert = true
                    return
                }
                var prevToken = token
                
                if idSaveToggle == false {
                    let postUser = PostUser(username: loginViewModel.login.user.id, password: loginViewModel.login.user.password)

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
                            self.token = json["data"]["token"].stringValue
                        default:
                            return
                        }
                    })
                } else{
                    print("self id", id)
                    let postUser = PostUser(username: self.id, password:loginViewModel.login.user.password)

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
                            self.token = json["data"]["token"].stringValue
                            if json["error"]["status"].intValue == 401{
                                shouldNavigate = false
                                showAlert = true
                                return
                            }
                            else {
                                shouldNavigate = true
                            }
                        default:
                            return
                        }

                    })
                }
                
                
                

                // shouldNavigate value
                // 로그인 안된 케이스
                if token == "" {
                    shouldNavigate = false
                }
//                // 토큰 갱신된 케이스
//                if token != prevToken {
//                    self.$shouldNavigate.wrappedValue = false
//                    print("토큰 갱신")
//                }
//                // 토큰 갱신 안된 케이스
//                else{
//                    self.$shouldNavigate.wrappedValue = true
//                    print("토큰 갱신 노노")
//                }
//
               
            }, label: {

                    Text("로그인")
                    .frame(width: 180, height: 20, alignment: .center)

                    .font(.body)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color("KWColor1"))
                    .cornerRadius(40)
            }) .alert("로그인 오류", isPresented: $showAlert) {
                Button("확인"){}
            } message: {
                Text("회원가입은 하셨나요? 하셨다면, 아이디/패스워드를 확인해주세요.")
            }

        })
       
        
    }
    
    // sign up Button
    var signUpBtn : some View {
        
        NavigationLink(destination: SignUpView(), label: {
            
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

// View Model
class LoginViewModel :ObservableObject {
  
    @Published var login = Login(user: User(id: "", password: "",token: ""))
    
}


struct PostUser : Encodable {
    var username : String
    var password : String
    
}
