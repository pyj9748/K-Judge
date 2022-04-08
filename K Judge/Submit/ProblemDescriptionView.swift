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
            VStack{
                GroupBox("문제 이름"){
                    Text(problemDetail.name)
                }
                GroupBox("문제"){
                    Text(problemDetail.description)
                }
                GroupBox("입력"){
                    Text(problemDetail.input_description)
                }
                GroupBox("출력"){
                    Text(problemDetail.output_description)
                }
            
                
            }.padding()
        }
       
    }
}

struct ProblemDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemDescriptionView(problemDetail: .constant(ProblemDetail(id: 1, name: "name", description: "des", input_description: "in_des", output_description: "out_des", score: 100)))
    }
}
