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
    @Binding var didIParticapted :Bool
    @State var shouldNavigate = false
    var body: some View {
        
        VStack{
//            HStack{
//                Text("문제 번호")
//                Spacer()
//
//                Text("문제 이름")
//
//            }.padding()
            ScrollView{
                VStack{
                    Text("").onAppear(){
                        print("ContestItemView \(challenge.id)")
                        // get problem list
                       
                        problemsViewModel.getProblemList(challengeId: challenge.id)
                       
                    }
                }
                
                
                ForEach($problemsViewModel.challengeProblemList){ item in
                    NavigationLink( destination:ProblemDetailView(challenge: item),label: {
                        ProblemListItem(problemListItem: item)
                    })
                   
                }
            }
            Spacer()
        }
    }
}

struct ProblemsView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemsView(challenge: .constant(Challenge(id: 1, name: "name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)), didIParticapted:.constant(false))
    }
}
