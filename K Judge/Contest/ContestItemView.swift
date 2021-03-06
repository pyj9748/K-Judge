//
//  ContestView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI
import Alamofire
import SwiftyJSON
struct ContestItemView: View {
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @AppStorage("id") var id: String = (UserDefaults.standard.string(forKey: "id") ?? "")
    @Binding var challenge : Challenge
    @StateObject var contestItemViewModel = ContestItemViewModel()
    @StateObject var contestInfoViewModel = ContestInfoViewModel()
    @State var didIParticapted = false
    @State var showParticapted = false
    @State var showParticapteFail = false
    @State var showParticapteAlready = false
    @State var showQuit = false
    @State var tabIndex = 0
    
    var body: some View {
        
       // NavigationView{
            VStack{
                Text("").onAppear(){
                    contestInfoViewModel.participationList = contestInfoViewModel.getParticipationList(challengeId: challenge.id)
                    print(contestInfoViewModel.participationList)
                    if contestInfoViewModel.participationList.contains(where: {
                        $0.name == id
                    }){
                        didIParticapted = true
                        
                    }else {
                        didIParticapted = false
                    }
                }
                ContestItemCustomTopTabBar(tabIndex: $tabIndex)
                if tabIndex == 0 {
                    ProblemsView(challenge: $challenge, didIParticapted: $didIParticapted)
                }
                else if tabIndex == 1 {
                    MySubmissionView(challenge: $challenge)
                }
                else if tabIndex == 2 {
                    ContestInfoView( didIParticapted: $didIParticapted,challenge: $challenge)
                }
                else {
                   ContestInfoUpdateView(challenge: $challenge)
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
            .padding(.horizontal, 12)
        
            .navigationBarTitle("\(challenge.name)",displayMode:.inline)
                .toolbar(content: {
                
                    // ?????? ?????? x
                    if didIParticapted == false {
                        registerBtn
                    }
                   
                    // ?????? ??????
                    else{
                        unRegisterBtn
                    }
                    
                })

        }
    //}
}

// status view
extension ContestItemView {
    var registerBtn : some View {
       
        Button(action: {
            print("registerBtn","username: ",id,"challeng id: ",challenge.id )
            // register api ???
        
            // Header
            let headers : HTTPHeaders = [
                        "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
            

            AF.request("\(baseURL):8080/api/challenges/\(challenge.id)/participations",
                       method: .post,
                       headers: headers).response { response in
                debugPrint(response)
            }.responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["data"]["message"].stringValue == "You have been successfully registered." {
                        didIParticapted = true
                        showParticapted = true
                        return
                    }
                    if json["error"]["message"].stringValue == "?????? ??????????????? ????????? ???????????????." {
                        didIParticapted = false
                        showParticapteFail = true
                        return
                    }
                    if json["error"]["message"].stringValue == "?????? ????????? ??????????????????." {
                        showParticapteAlready = true
                        didIParticapted = true
                        
                        return
                    }
                   
                   
                   
                default:
                    
                    return
                }

            })
            
        }, label: {
            HStack {
                    Image(systemName: "square.and.arrow.down")
                    .font(.body)
                    Text("??????     ")
                        .fontWeight(.semibold)
                        .font(.body
                        )
                }
                .padding(6)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        }).alert("??????", isPresented: $showParticapted) {
            Button("??????"){}
        } message: {
            Text("???????????? ??????")
        }
        .alert("??????", isPresented: $showParticapteFail) {
            Button("??????"){}
        } message: {
            Text("?????? ??????????????? ????????? ???????????????.")
        } .alert("??????", isPresented: $showParticapteAlready) {
            Button("??????"){}
        } message: {
            Text("?????? ????????? ??????????????????.")
        }.alert("??????", isPresented: $showQuit) {
            Button("??????"){}
        } message: {
            Text("?????????????????? ??????")
        }
       
    }
    var unRegisterBtn : some View {
       
        Button(action: {
            print("unRegisterBtn")
           
            // unregister api ???
        
            // Header
            let headers : HTTPHeaders = [
                        "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
            

            AF.request("\(baseURL):8080/api/challenges/\(challenge.id)/participations/",
                       method: .delete,
                       headers: headers).response { response in
                debugPrint(response)
            }.responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["data"]["message"].stringValue == "You have been successfully canceled." {
                        didIParticapted = false
                        showQuit = true
                        return
                    }
                   
                default:
                    
                    return
                }

            })
            
            
        }, label: {
            HStack {
                    Image(systemName: "square.and.arrow.up")
                    .font(.body)
                    Text("?????? ??????   ")
                        .fontWeight(.semibold)
                        .font(.body
                        )
                }
                .padding(6)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        }).alert("??????", isPresented: $showParticapted) {
            Button("??????"){}
        } message: {
            Text("???????????? ??????")
        }
        .alert("??????", isPresented: $showParticapteFail) {
            Button("??????"){}
        } message: {
            Text("?????? ??????????????? ????????? ???????????????.")
        } .alert("??????", isPresented: $showParticapteAlready) {
            Button("??????"){}
        } message: {
            Text("?????? ????????? ??????????????????.")
        }
        
        .alert("??????", isPresented: $showQuit) {
            Button("??????"){}
        } message: {
            Text("?????????????????? ??????")
        }
    }
    
}




struct ContestItemCustomTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 20) {
            TabBarButton(text: " ?????? ", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            TabBarButton(text: " ???????????? ", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            TabBarButton(text: " ????????? ", isSelected: .constant(tabIndex == 2))
                .onTapGesture { onButtonTapped(index: 2) }
            TabBarButton(text: " ?????? ", isSelected: .constant(tabIndex == 3))
                .onTapGesture { onButtonTapped(index: 3) }
//            TabBarButton(text: "STATUS", isSelected: .constant(tabIndex == 2))
//                .onTapGesture { onButtonTapped(index: 2) }
            Spacer()
        }
        .border(width: 1, edges: [.bottom], color: Color("DefaultTextColor"))
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.custom("Arial", size: 16))
            .font(.custom("Avenir", size: 16))
            .padding(.bottom,10)
            .border(width: isSelected ? 2 : 1, edges: [.bottom], color: Color("DefaultTextColor"))
    }
}

struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
struct ContestItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContestItemView(challenge:.constant(Challenge(id: 1, name: "challenge name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)))
    }
}


