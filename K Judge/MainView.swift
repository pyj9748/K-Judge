//
//  MainView.swift
//  K Judge
//
//  Created by young june Park on 2022/04/02.
//


import SwiftUI
enum Tab {
    case Problems
    case Create
    case Setting
}
struct MainView: View {
   
    @State private var selection:Tab = .Problems
    
    var body: some View {
      
            
        ZStack{
            
            
            TabView {

               ProblemView()
                    .tabItem{
                            Image(systemName: "folder")
                            Text("문제")
                    }
                // 문제 생성 탭
                CreateView()
                    .tabItem{
                            Image(systemName: "pencil")
                            Text("문제생성")
                    }
                // 대회 탭
                ContestView()
                    .tabItem{
                            Image(systemName: "list.bullet.rectangle")
                            Text("대회")
                    }
                
                
                    
                 
            }
            .accentColor(Color.blue)
           // .navigationBarHidden(true)
            //.navigationTitle("")
            //.navigationBarBackButtonHidden(true)
            
           
        }
      
       
            
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
