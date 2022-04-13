//
//  ProblemDescriptionView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

import SwiftUI

struct ProblemDescriptionView: View {
    @Binding var problemDetail : ProblemDetail
    var body: some View {
      
            ScrollView{
                HStack{
                VStack(alignment: .leading){
                    // Name
                        VStack(alignment:.leading){
                            Text("문제 이름").font(.headline)
                            Text(" ")
                            Text( problemDetail.name )
                                .textFieldStyle(.roundedBorder)
                            Text(" ")
                        }
                    // Description
                        VStack(alignment:.leading){
                            Text("문제").font(.headline)
                            Text(" ")
                            Text(problemDetail.description)
                            Text(" ")
                        }
                    // input_description
                        VStack(alignment:.leading){
                            Text("입력").font(.headline)
                            Text(" ")
                            Text(problemDetail.input_description)
                            Text(" ")
                        }
                    // output_description
                        VStack(alignment:.leading){
                            Text("출력").font(.headline)
                            Text(" ")
                            Text(problemDetail.output_description)
                            Text(" ")
                        }
                }.padding()
                    Spacer()
                }
            }
         
        
       
    }
}

struct ProblemDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemDescriptionView(problemDetail: .constant(ProblemDetail(id: 1, name: "name", description: "des", input_description: "in_des", output_description: "out_des", score: 100)))
    }
}
