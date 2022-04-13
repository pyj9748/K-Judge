//
//  ContestListItemView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ContestListItemView: View {
   
   @Binding var challengeListItem : Challenge
   
    @State var start = Date()
    @State var end = Date()
    var body: some View {
        
            
        
        HStack{
            
                HStack(spacing: 10){
                    Image(systemName: "octagon")
                        .font(.largeTitle)
                        
                    
                    VStack(alignment:.leading){
                        
                        Text(challengeListItem.name).foregroundColor(Color("DefaultTextColor"))
                            .font(.bold(.title)())
                        Text("대회시작 : \(self.editDate(str: challengeListItem.start_time))").foregroundColor(Color("DefaultTextColor"))
                        Text("대회종료 : \(self.editDate(str: challengeListItem.end_time))").foregroundColor(Color("DefaultTextColor"))
                    }
                }.padding(.horizontal)
               
            
            Spacer()
        }.padding(3)
        .border(width: 0.6, edges: [.bottom], color: Color("DefaultTextColor"))

    }
}

extension ContestListItemView {
    func editDate(str:String) -> String {
        let startIndex1 = str.startIndex
        let endIndex1 = str.index(startIndex1, offsetBy: 9)
        var str1 = str[startIndex1...endIndex1]
        let startIndex2 = str.index(startIndex1, offsetBy: 11)
        let endIndex2 = str.index(startIndex2, offsetBy: 4)
        var str2 = str[startIndex2...endIndex2]
        str1 += " "
        str1 += str2
        return String(str1)
    }
    
}

struct ContestListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContestListItemView(challengeListItem: .constant(Challenge(id: 1, name: "name", start_time: "0401", end_time: "0402", num_of_participation: 2, num_of_question: 2)))
    }
}
