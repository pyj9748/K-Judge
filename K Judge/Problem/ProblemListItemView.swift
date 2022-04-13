//
//  ProblemListItemView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ProblemListItemView: View {
    @Binding var problemListItem : ProblemCatalogs
     
     var body: some View {
         HStack(alignment:.center){
             Image(systemName: "octagon")
                 .font(.largeTitle)
                 
                 HStack(spacing: 10){
                     
                     
                     VStack(alignment: .leading){
                         
                         Text(problemListItem.name).foregroundColor(Color("DefaultTextColor")).font(.bold(.title)())
                         Text("문제 아이디 : \(String(problemListItem.id))").foregroundColor(Color("DefaultTextColor"))
                         Text("점수   : \(String(problemListItem.score))").foregroundColor(Color("DefaultTextColor"))
                     }
                     Spacer()
                 }
             
            
         } .padding(3)
             .border(width: 0.6, edges: [.bottom], color: Color("DefaultTextColor"))

          
        
        
           
        
            
         
             
        
        
     }
}

struct ProblemListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemListItemView(problemListItem: .constant(ProblemCatalogs(id: "1", name: "problem1", score: "100")))
    }
}
