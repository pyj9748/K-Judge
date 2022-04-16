//
//  ProblemsView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

// View
struct ProblemView: View {
    @StateObject var problemViewModel = ProblemViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                ProblemListView()
            } .navigationBarTitle("문제목록",displayMode:.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: UserInfoView(), label: {
                           
                                Image(systemName: "person.crop.circle")
                                .font(.body)
                            
                            
                        })
                    }
                   
                })
        }.navigationBarBackButtonHidden(true)
    }
}

struct ProblemView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemView()
    }
}
