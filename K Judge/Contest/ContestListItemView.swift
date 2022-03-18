//
//  ContestListItemView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ContestListItemView: View {
    
   @Binding var contentListItem : Contest
    
    var body: some View {
        GroupBox{
            HStack{
                Text(contentListItem.name)
                Spacer()
                VStack{
                    ForEach (contentListItem.authors) { author in
                        Text(author.name)
                    }
                }
                Spacer()
                Text(contentListItem.challenge_date_time.start_time)
                Spacer()
                Text(contentListItem.challenge_date_time.end_time)
            }
        }
       
    }
}

struct ContestListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContestListItemView(contentListItem: .constant(Contest(id: UUID(), authors: [Author(id : UUID(),user_id: "0", name: "martin", accumulate_score: "100"),Author(id : UUID(),user_id: "1", name: "kate", accumulate_score: "200")], name: "contest1", challenge_date_time: Challenge_date_time(start_time: "start time", end_time: "end time"), questions: [])))
    }
}
