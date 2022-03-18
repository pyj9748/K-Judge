//
//  ContentView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI
enum Tab {
    case Problems
    case Create
    case Setting
}
struct ContentView: View {
   
    @State private var selection:Tab = .Problems
    
    var body: some View {
        ZStack{
            
            
            TabView {

               ProblemView()
                    .tabItem{
                            Image(systemName: "folder")
                            Text("Problems")
                    }
                // 문제 생성 탭
                CreateView()
                    .tabItem{
                            Image(systemName: "pencil")
                            Text("Create")
                    }
                // 대회 탭
                ContestView()
                    .tabItem{
                            Image(systemName: "list.bullet.rectangle")
                            Text("Contest")
                    }
                
                
                SubmitView()
                    .tabItem{
                        Image(systemName: "lightbulb")
                            Text("Submit")
                    }
                 
            }
            .accentColor(Color.blue)
           
        }
       
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
