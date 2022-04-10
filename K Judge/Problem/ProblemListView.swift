//
//  ProblemListView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ProblemListView: View {
    @StateObject var problemListViewModel = ProblemListViewModel()
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
  
    var body: some View {
        VStack(alignment : .leading){
              

            ScrollView{
                ForEach($problemListViewModel.problemList){ item in
                    NavigationLink(destination:ProblemItemView(problemId: .constant(item.id)), label: {
                        ProblemListItemView(problemListItem:item)
                    })
                   
                }
            }.padding()
            
            Spacer()
              
        }.onAppear(){
            problemListViewModel.problemList = problemListViewModel.getProblemList(token: token)
        }
     
        
        

    }
}

struct ProblemListView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemListView()
    }
}
