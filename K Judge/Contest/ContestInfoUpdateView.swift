//
//  ContestInfoUpdateView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ContestInfoUpdateView: View {
    @Binding var challenge : Challenge
   
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
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(40)
                
            })
            Spacer()
            NavigationLink(destination:AuthorEditView(challengeId: $challenge.id), label: {
                
                HStack {
                Image(systemName: "person.2")
                    .font(.title)
                Text("주최자 수정")
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(40)
              
            })
            Spacer()
            NavigationLink(destination:QuestionEditView(challengeId: $challenge.id), label: {
                
                HStack {
                Image(systemName: "square.grid.3x1.folder.badge.plus")
                    .font(.title)
                Text("문제수정")
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(40)
               
            })
        }
       
        
    }
}

// 정보 수정
extension ContestInfoUpdateView{
    var infoUpdate : some View{
        Text("info Update")
    }
}

// 출제자 수정
extension ContestInfoUpdateView{
    var authorUpdate : some View{
        Text("author Update")
    }
}
// 문제 수정
extension ContestInfoUpdateView{
    var questionsUpdate : some View{
        Text("questions Update")
    }
}
struct ContestInfoUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ContestInfoUpdateView(challenge: .constant(Challenge(id: 1, name: "name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)))
    }
}
