//
//  ProblemListView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ProblemListView: View {
    @StateObject var problemListViewModel = ProblemListViewModel()
    @AppStorage("id") var id: String = (UserDefaults.standard.string(forKey: "id") ?? "")
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @AppStorage("password") var password: String = (UserDefaults.standard.string(forKey: "password") ?? "")
   
  
    var body: some View {
        VStack(alignment : .leading){
              

            ScrollView{
                ForEach($problemListViewModel.problemList){ item in
                    NavigationLink(destination:ProblemItemView(problemId: .constant(item.id)), label: {
                        ProblemListItemView(problemListItem:item)
                            .padding(.horizontal)
                    })
                   
                }
            }
            
            Spacer()
              
        }
        .onAppear(){
            problemListViewModel.problemList = problemListViewModel.getProblemList(token: token)
//            print("토큰 갱신 여부 \(problemListViewModel.needToRenewToken)")
//            if problemListViewModel.needToRenewToken == true {
//
//                self.token = renewToken(id: self.id, password: self.password){
//                    problemListViewModel.needToRenewToken = false
//                    problemListViewModel.problemList = problemListViewModel.getProblemList(token: token)
//                }
//
//
//            }
//            else {
//                problemListViewModel.problemList = problemListViewModel.getProblemList(token: token)
//            }
            
        }
     
        
        

    }
}

struct ProblemListView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemListView()
    }
}
