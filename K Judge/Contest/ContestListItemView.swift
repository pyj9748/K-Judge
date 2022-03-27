//
//  ContestListItemView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ContestListItemView: View {
    
   @Binding var challengeListItem : Challenge
    var dateFormatter = DateFormatter()
    
    var body: some View {
        GroupBox{
            HStack{
                Spacer()
                Text(challengeListItem.name).frame(width:70, height: 50 )
                Spacer()
                start_dateText.frame(width: 100, height: 50 )
                Spacer()
                end_dateText.frame(width: 100, height: 50 )
                Spacer()
            }
        }
       
    }
}
extension ContestListItemView {
    var start_dateText : some View {
       
        Text(challengeListItem.start_time)
    }
    
    var end_dateText : some View {
     
        Text(challengeListItem.end_time)
    }
  
}


struct ContestListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContestListItemView(challengeListItem: .constant(Challenge(id: 1, name: "name", start_time: "0401", end_time: "0402", num_of_participation: 2, num_of_question: 2)))
    }
}
