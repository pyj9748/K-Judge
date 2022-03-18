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
         GroupBox{
             HStack{
                 Text(String(problemListItem.id))
                 Spacer()
                 Text(problemListItem.name)
                 Spacer()
                 Text(String(problemListItem.score))
             }
         }
        
     }
}

struct ProblemListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemListItemView(problemListItem: .constant(ProblemCatalogs(id: "1", name: "problem1", score: "100")))
    }
}
