//
//  ProblemSelectionView.swift
//  K Judge
//
//  Created by young june Park on 2022/04/10.
//

import SwiftUI

struct ProblemSelectionView: View {
    @Binding var problemList : [ProblemCatalogs]
    @Binding var multiSelection : Set<String>
    var body: some View {
        //NavigationView{
            List(problemList,selection: $multiSelection){
               
                Text($0.name)
            
            }
            .toolbar { EditButton() }
       // }
       
    }
}

struct ProblemSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemSelectionView(problemList: .constant([]),multiSelection: .constant([]))
    }
}
