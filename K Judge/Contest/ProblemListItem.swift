//
//  ProblemListItem.swift
//  K Judge
//
//  Created by young june Park on 2022/03/20.
//

import SwiftUI

struct ProblemListItem: View {
    @Binding var problemListItem : Problem
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

struct ProblemListItem_Previews: PreviewProvider {
    static var previews: some View {
        ProblemListItem(problemListItem: .constant(Problem(id: "1", name: "name1", description: Description(description: "description", input_description: "input_description", output_description: "output_description"), limit: Limit(memory: "", time: ""), score: "100")))
    }
}
