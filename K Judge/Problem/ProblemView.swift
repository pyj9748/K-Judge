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
            } .navigationBarTitle("Problems",displayMode:.inline)
        }
    }
}

struct ProblemView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemsView()
    }
}
