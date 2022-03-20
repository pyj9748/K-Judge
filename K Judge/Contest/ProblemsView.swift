//
//  ProblemsView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

struct ProblemsView: View {
    @Binding var contest : Contest
    
    var body: some View {
        
        ScrollView{
            VStack{
                nameText
                
            }
        }
        
        
    }
}

extension ProblemsView {
    
    // Name
    var nameText: some View{
        GroupBox("Name"){
            
        }
    }
   
    
    
}




struct ProblemsView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemsView(contest: .constant(Contest(id: "1", authors: [Author( user_id: "1", name: "a1", accumulate_score: "1")], name: "contest1", challenge_date_time: Challenge_date_time(start_time: Date(), end_time: Date()), questions: [1,2,3,4])))
    }
}
