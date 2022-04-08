//
//  ProblemListItem.swift
//  K Judge
//
//  Created by young june Park on 2022/03/20.
//

import SwiftUI

struct ProblemListItem: View {
    @Binding var problemListItem : ChallengeProblem
    var body: some View {
        GroupBox{
            HStack{
                Text(String(problemListItem.problem_id)).onAppear(){
                    print(problemListItem.problem_id)
                    
                }
                Spacer()
                Text(problemListItem.title)
                
            }
        }
    }
}

struct ProblemListItem_Previews: PreviewProvider {
    static var previews: some View {
        ProblemListItem(problemListItem: .constant(ChallengeProblem(id: 1, problem_id: 1, title: "asd",challeng_id: 1)))
    }
}
