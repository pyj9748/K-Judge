//
//  ProblemDescriptionView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

import SwiftUI

struct ProblemDescriptionView: View {
    var body: some View {
        ScrollView{
            VStack{
                GroupBox("Name"){
                    Text("name")
                }
                GroupBox("Description"){
                    Text("name")
                }
                GroupBox("InPut Description"){
                    Text("name")
                }
                GroupBox("OutPut Description"){
                    Text("name")
                }
                GroupBox("InPut File1"){
                    Text("name")
                }
                GroupBox("OutPut File1"){
                    Text("name")
                }
                GroupBox("InPut File2"){
                    Text("name")
                }
                GroupBox("OutPut File2"){
                    Text("name")
                }
                GroupBox("Memory"){
                    Text("name")
                }
                GroupBox("Time"){
                    Text("name")
                }
                
            }.padding()
        }
       
    }
}

struct ProblemDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemDescriptionView()
    }
}
