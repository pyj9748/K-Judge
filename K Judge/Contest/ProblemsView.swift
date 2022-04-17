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
                Group{
                    if problemsViewModel.getNowDate() > challenge.start_time{
                        
                        ForEach($problemsViewModel.challengeProblemList){ item in
                            NavigationLink( destination:ProblemDetailView(challenge: item),label: {
                                ProblemListItem(problemListItem: item)
                            })
                        }
                    }
                    else {
                        Text("대회 시작시각 이전에는 문제정보를 볼 수 없습니다.")
                    }
                    
                   
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
