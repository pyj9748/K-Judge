//
//  ContentView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI

struct ContentView: View {
   
    @State private var selection:Tab = .Problems
    
    var body: some View {
        LoginView().navigationBarHidden(true)
        //MainView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
