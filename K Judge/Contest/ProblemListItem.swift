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
      
        
        HStack{
            
                HStack(spacing: 10){
                    Image(systemName: "octagon")
                        .font(.largeTitle)
                        
                    
                    VStack(alignment: .leading){
                        
                        Text(problemListItem.title)
                            .foregroundColor(Color("DefaultTextColor"))
                            .font(.bold(.title)())
                            
                        Text("문제 아이디 : \(String(problemListItem.problem_id))").foregroundColor(Color("DefaultTextColor"))
                       
                    }.padding(.horizontal)
                }
               
               
            
            Spacer()
        }.padding(3)
            .border(width: 0.6, edges: [.bottom], color: Color("DefaultTextColor"))
    }
}

struct ProblemListItem_Previews: PreviewProvider {
    static var previews: some View {
        ProblemListItem(problemListItem: .constant(ChallengeProblem(id: 1, problem_id: 1, title: "asd",challeng_id: 1)))
    }
}
