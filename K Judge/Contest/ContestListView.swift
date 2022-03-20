//
//  ContestListView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ContestListView: View {
    
    @StateObject var contestListViewModel = ContestListViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Text("Name").frame(width: 70, height: 50 )
                Spacer()
                Text("Authors").frame(width: 70, height: 50 )
                Spacer()
                Text("start").frame(width: 100, height: 50 )
                Spacer()
                Text("end").frame(width: 100, height: 50 )
            }.padding()
            ScrollView{
                ForEach($contestListViewModel.contestList){ item in
                    NavigationLink(destination: ContestItemView(contest: item), label: {
                        ContestListItemView(contentListItem:item)
                    })
                   
                }
            }.padding()
            Spacer()

        }
        
    }
}



struct ContestListView_Previews: PreviewProvider {
    static var previews: some View {
        ContestListView()
    }
}
