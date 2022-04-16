//
//  ContestInfoUpdateView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI
import Alamofire
struct ContestInfoUpdateView: View {
    @Binding var challenge : Challenge
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    var body: some View {
       
        VStack{
            NavigationLink(destination:InfoEditView(challengeId: $challenge.id , name: challenge.name , start: Date(),end: Date()), label: {
                HStack {
                        Image(systemName: "highlighter")
                            .font(.title)
                        Text("정보수정")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .padding(30)
                    .foregroundColor(.white)
                    .background(Color("KWColor1"))
                    .cornerRadius(10)
                
            })
       
           
            NavigationLink(destination:QuestionEditView(challengeId: $challenge.id), label: {
                
                HStack {
                Image(systemName: "square.grid.3x1.folder.badge.plus")
                    .font(.title)
                Text("문제수정")
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .padding(30)
            .foregroundColor(.white)
            .background(Color("KWColor1"))
            .cornerRadius(10)
               
            })
            
            
            Button(action: {
                
               
                
                let headers : HTTPHeaders = [
                    "Content-Type" : "application/json","Authorization": "Bearer \(self.token)" ]
                let post = 1
                AF.request("\(baseURL):8080/api/challenges/\(challenge.id)/grading",
                           method: .post,
                           parameters: post,
                           encoder: JSONParameterEncoder.default,headers: headers).response { response in
                    debugPrint(response)
                }
            }, label: {
                
                HStack {
                Image(systemName: "hourglass.tophalf.filled")
                    .font(.title)
                Text("대회종료")
                    .fontWeight(.semibold)
                    .font(.title)
                }
                
            }).padding(30)
                .padding(.horizontal, 8)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(10)
            
            
         
    }
       
        
}
}

//// 정보 수정
//extension ContestInfoUpdateView{
//    var infoUpdate : some View{
//        Text("info Update")
//    }
//}
//
//// 출제자 수정
//extension ContestInfoUpdateView{
//    var authorUpdate : some View{
//        Text("author Update")
//    }
//}
//// 문제 수정
//extension ContestInfoUpdateView{
//    var questionsUpdate : some View{
//        Text("questions Update")
//    }
//}
struct ContestInfoUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ContestInfoUpdateView(challenge: .constant(Challenge(id: 1, name: "name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)))
    }
}
