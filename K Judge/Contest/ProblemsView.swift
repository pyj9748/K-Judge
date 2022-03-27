//
//  ProblemsView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

struct ProblemsView: View {
    @Binding var challenge : Challenge
    @StateObject var problemsViewModel = ProblemsViewModel()
    
    var body: some View {
        
        VStack{
            HStack{
                Text("Problem Id")
                Spacer()
             
                Text("Title")
               
            }.padding()
            ScrollView{
                VStack{
                    Text("").onAppear(){
                        //print("ContestItemView \(challenge.id)")
                        // get problem list
                        problemsViewModel.challengeProblemList = problemsViewModel.getProblemList(challengeId: challenge.id)
                    }
                }
                ForEach($problemsViewModel.challengeProblemList, id: \.id){ item in
                    NavigationLink(destination:ProblemDetailView(challenge: item), label: {
                        ProblemListItem(problemListItem: item)
                    })
                   
                }
            }.padding()
            Spacer()
        }
    }
}

struct ProblemsView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemsView(challenge: .constant(Challenge(id: 1, name: "name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)))
    }
}
