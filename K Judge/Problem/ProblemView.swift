//
//  ProblemsView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

// View
struct ProblemView: View {
    @StateObject var problemViewModel = ProblemViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    var body: some View {
        NavigationView{
            VStack{
                ProblemListView()
            } .navigationBarTitle("문제목록",displayMode:.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: UserInfoView(), label: {
                           
                                Image(systemName: "person.crop.circle")
                                .font(.body)
                            
                            
                        })
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            print("LogOut")
                            // 메모리 숫자인지
                            token = ""
                            presentationMode.wrappedValue.dismiss()
                            
                        }, label: {
                            HStack {
                    //                Image(systemName: "pencil.circle")
                    //                .font(.body)
                                    Text("로그아웃     ")
                                        .fontWeight(.semibold)
                                        .font(.body
                                        )
                                }
                                .padding(6)
                                .foregroundColor(.white)
                                .background(Color("KWColor1"))
                                .cornerRadius(40)
                        })
                    }
                })
        }.navigationBarBackButtonHidden(true)
    }
}

struct ProblemView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemView()
    }
}
//var logoutBtn : some View {
//    Button(action: {
//        print("LogOut")
//        // 메모리 숫자인지
//        presentationMode.wrappedValue.dismiss()
//        
//    }, label: {
//        HStack {
////                Image(systemName: "pencil.circle")
////                .font(.body)
//                Text("로그아웃     ")
//                    .fontWeight(.semibold)
//                    .font(.body
//                    )
//            }
//            .padding(6)
//            .foregroundColor(.white)
//            .background(Color("KWColor1"))
//            .cornerRadius(40)
//    })
// 
//        
//    
//}

