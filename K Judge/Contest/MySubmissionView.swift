//
//  MySubmissionView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

struct MySubmissionView: View {
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @Binding var challenge : Challenge
    @StateObject var mySubmissionViewModel = MySubmissionViewModel()
    var body: some View {
        VStack{
            HStack{
                Text("문제 번호")
                Spacer()
             
                Text("제출 시각")
                Spacer()
                Text("제출 상태")
               
            }.padding()
            ScrollView{
                VStack{
                    Text("").onAppear(){
                        print("MySubmissionView \(challenge.id)")
                        // get submission list
                        mySubmissionViewModel.submissionList =
                        mySubmissionViewModel.getSubmissionList(challengeId: challenge.id, token: token )
                       
                       
                    }
                }
                ForEach($mySubmissionViewModel.submissionList ){ item in
                    NavigationLink(destination:SubmissionDetailView(challengeId: $challenge.id,submissionId:.constant(item.id.wrappedValue)),label: {
                        SubmissionListItem(submissionListItem: item)
                    })
                   
                }
                    
               
            }.padding()
            Spacer()
        }
    }
}

struct MySubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        MySubmissionView(challenge: .constant(Challenge(id: 1, name: "name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)))
    }
}
