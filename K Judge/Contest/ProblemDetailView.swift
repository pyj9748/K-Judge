//
//  ProblemDetailView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/20.
//

import SwiftUI

struct ProblemDetailView: View {
    @Binding var problem : Problem
    var body: some View {
        ScrollView{
            VStack{
                nameText
                descriptionText
                input_descriptionText
                output_descriptionText
                scoreText
            }
        }
    }
}


extension ProblemDetailView {
    
    // Name
    var nameText: some View{
        GroupBox("Name"){
            Text(problem.name )
                .textFieldStyle(.roundedBorder)
        }
    }
    
    // Description
    var descriptionText : some View{
        GroupBox("Description"){
            Text(problem.description.description)
        }
    }
   
    // input_description
    var input_descriptionText : some View{
        GroupBox("InPut Description"){
            Text(problem.description.input_description)
        }
    }
   
    // output_description
    var output_descriptionText: some View{
        GroupBox("OutPut Description"){
            Text(problem.description.output_description)
        }
    }

    // score
    var scoreText : some View{
        GroupBox("Score"){
            Text(problem.score)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    
}


struct ProblemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemDetailView(problem: .constant(Problem(id: "1", name: "name1", description: Description(description: "description", input_description: "input_description", output_description: "output_description"), limit: Limit(memory: "", time: ""), score: "100")))
    }
}
