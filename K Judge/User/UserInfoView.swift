//
//  UserInfoView.swift
//  K Judge
//
//  Created by young june Park on 2022/04/16.
//

import SwiftUI
import SwiftyJSON
import Alamofire

struct UserInfo :Codable,Identifiable{
    
    var id : Int
    var name : String
    var accumulate_score : Int
    var rank : String
    
}

struct UserInfoView: View {
    //@State private var isActive : Bool = false
   
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @StateObject var userInfoViewModel = UserInfoViewModel()
   
    
    
    var body: some View {
        NavigationView{
            VStack{
                Text("").onAppear(){
                    userInfoViewModel.userInfo = userInfoViewModel.getUserInfo(token: token)
                }
                userInfoSection
                //logoutBtn
            }
        }
        
    }
}
extension UserInfoView {
    
//    var logoutBtn : some View {
//        NavigationLink(destination:ContentView(), isActive: $isActive ,label: {
//
//
//            Button(action: {
//                self.token = ""
//
//                print("LogOut")
//
//
//                isActive = true
//
//
//
//            }, label: {
//
//                Text("๋ก๊ทธ์์")
//                .frame(width: 180, height: 20, alignment: .center)
//
//                .font(.body)
//                .padding(10)
//                .foregroundColor(.white)
//                .background(Color("KWColor1"))
//                .cornerRadius(40)
//            })
//        })
//
//
//    }
    
    var userInfoSection : some View {
        
        VStack(){
            VStack(alignment:.leading){
                
                Text(" ")
                Text(self.$userInfoViewModel.userInfo.name.wrappedValue)
                    .font(.largeTitle)
                    .foregroundColor(Color("DefaultTextColor"))
                Text(" ")
            }
            HStack(alignment: .center){
                Group{
                    if self.$userInfoViewModel.userInfo.rank.wrappedValue == "GOLD"{
                        Text("๐ฅ").font(.system(size: 80))
                    }
                    else if self.$userInfoViewModel.userInfo.rank.wrappedValue == "SILVER"{
                        Text("๐ฅ").font(.system(size: 80))
                    }
                    else if self.$userInfoViewModel.userInfo.rank.wrappedValue == "BRONZE" {
                        Text("๐ฅ").font(.system(size: 80))
                    }
                    else {
                        Text("๐ฑ").font(.system(size: 80))
                    }
                }
                Text(" ")
                Text("\(self.$userInfoViewModel.userInfo.rank.wrappedValue) ๋ฑ๊ธ ์๋๋ค!") .font(.headline)
                    .foregroundColor(Color("DefaultTextColor"))
                Text(" ")
                
            }
           
            VStack(alignment:.center){
               
                Text("์ด ์?์๋ \(self.userInfoViewModel.userInfo.accumulate_score) ")
                    .font(.headline)
                    .foregroundColor(Color("DefaultTextColor"))
                Text("")
                Group{
                    if self.userInfoViewModel.userInfo.rank == "GOLD"{
                        Text("์ต๊ณ? ๋ฑ๊ธ์๋๋ค. ๋ฉ์?ธ์!")
                            .font(.headline)
                            .foregroundColor(Color("DefaultTextColor"))
                    }
                    else if self.userInfoViewModel.userInfo.rank == "SILVER"{
                        Text("๋ค์ ๋ฑ๊ธ๐ฅ ๊น์ง \(3000 - self.userInfoViewModel.userInfo.accumulate_score )์? ๋จ์์ต๋๋ค!")
                            .font(.headline)
                            .foregroundColor(Color("DefaultTextColor"))
                    }
                    else if self.userInfoViewModel.userInfo.rank == "BRONZE"{
                        Text("๋ค์ ๋ฑ๊ธ๐ฅ ๊น์ง \(2000 - self.userInfoViewModel.userInfo.accumulate_score )์? ๋จ์์ต๋๋ค!") .font(.headline)
                            .foregroundColor(Color("DefaultTextColor"))
                    }
                    else {
                        Text("๋ค์ ๋ฑ๊ธ๐ฅ ๊น์ง \(1000 - self.userInfoViewModel.userInfo.accumulate_score )์? ๋จ์์ต๋๋ค!") .font(.headline)
                            .foregroundColor(Color("DefaultTextColor"))
                    }
                }
                
                Text(" ")
            }
            Spacer()
        }
    }
    
}


// View Model
class UserInfoViewModel : ObservableObject {
    
    @Published var userInfo : UserInfo = UserInfo(id: 0, name: "์์ค", accumulate_score: 1100, rank: "BRONZE")
    
   
}

// ์๋ฒ์์ problem List ๋ฐ์์ค๊ธฐ
extension UserInfoViewModel {
    func getUserInfo(token:String) -> UserInfo{
        var userInfo :UserInfo = UserInfo(id: 0, name: "dudwns", accumulate_score: 0, rank: "")
        print("getUserInfo")
        
        // api call - ๋ฌธ์? ๋ชฉ๋ก์กฐํ
        let url = URL(string: "\(baseURL):8080/api/users")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
//        let parameters : [String: Any] = [
//                       "page": 0,
//                       "size": 300  // ์ฌ๊ธฐ๋ ํ๋ฒ์ ๊ฐ์?ธ์ฌ ๋ฌธ์? ๊ฐ์ ๊ฐ
//                   ]
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json","Authorization": "Bearer \(token)"])
          
             .responseJSON(completionHandler: { response in
                 //์ฌ๊ธฐ์ ๊ฐ์?ธ์จ ๋ฐ์ดํฐ๋ฅผ ์์?๋กญ๊ฒ ํ์ฉํ์ธ์.
                 switch response.result{
                 case.success(let value):
                     //print(response)
                     
                     let json = JSON(value)
                     
                     let info = UserInfo(id: json["data"]["id"].intValue, name: json["data"]["name"].stringValue, accumulate_score:  json["data"]["accumulate_score"].intValue, rank: json["data"]["rank"].stringValue)

                     self.userInfo = info
                  
                     userInfo = info
                 case.failure(let error) :
                     print(error.localizedDescription)
                 }
               
             })
       
        return userInfo
        
    }
}




struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}


struct RootPresentationModeKey: EnvironmentKey {
  static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
  var rootPresentationMode: Binding<RootPresentationMode> {
    get { return self[RootPresentationModeKey.self] }
    set { self[RootPresentationModeKey.self] = newValue }
  }
}

typealias RootPresentationMode = Bool

public extension RootPresentationMode {
  mutating func dismiss() {
    self.toggle()
  }
}
