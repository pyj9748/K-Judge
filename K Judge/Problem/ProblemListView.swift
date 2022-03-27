//
//  ProblemListView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ProblemListView: View {
    @StateObject var problemListViewModel = ProblemListViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Text("id").onAppear(perform: {
                    problemListViewModel.problemList = problemListViewModel.getProblemList()
                
                })
                Spacer()
                Text("name")
                Spacer()
                Text("score")
               
            }.padding()
            ScrollView{
                ForEach($problemListViewModel.problemList){ item in
                    NavigationLink(destination:ProblemItemView(problemId: .constant(item.id)), label: {
                        ProblemListItemView(problemListItem:item)
                    })
                   
                }
            }.padding()
            Spacer()
        }
     
        
        

    }
}

struct ProblemListView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemListView()
    }
}
