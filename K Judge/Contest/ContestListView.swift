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
                Text("Name")
                Spacer()
                Text("Authors")
                Spacer()
                Text("start")
                Spacer()
                Text("end")
            }.padding()
            ScrollView{
                ForEach($contestListViewModel.contestList){ item in
                    NavigationLink(destination: ContestItemView(), label: {
                        ContestListItemView(contentListItem:item)
                    })
                   
                }
            }//.padding()
            Spacer()

        }
        
    }
}



struct ContestListView_Previews: PreviewProvider {
    static var previews: some View {
        ContestListView()
    }
}
