//
//  ContestListItemView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ContestListItemView: View {
    
   @Binding var contentListItem : Contest
    var dateFormatter = DateFormatter()
    
    var body: some View {
        GroupBox{
            HStack{
                Spacer()
                Text(contentListItem.name).frame(width:70, height: 50 )
                Spacer()
                VStack{
                    ForEach (contentListItem.authors , id: \.user_id) { author in
                        Text(author.name)
                    }
                }.frame(width: 70, height: 50 )
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
        
        Text(getStartDate())
    }
    
    var end_dateText : some View {
        
        Text(getEndDate())
    }
}

extension ContestListItemView {
    func getStartDate() -> String{
        let start_date = Calendar.current.date(byAdding: .day, value: 0, to: contentListItem.challenge_date_time.start_time)
        return start_date!.formatted()
    }
    
    func getEndDate()-> String {
        let end_date = Calendar.current.date(byAdding: .day, value: 0, to: contentListItem.challenge_date_time.end_time)
        return end_date!.formatted()
    }
    
}
struct ContestListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContestListItemView(contentListItem: .constant(Contest(id: "id", authors: [Author(user_id: "0", name: "martin", accumulate_score: "100"),Author(user_id: "1", name: "kate", accumulate_score: "200")], name: "contest1", challenge_date_time: Challenge_date_time(start_time: Date(), end_time: Date()), questions: [])))
    }
}
