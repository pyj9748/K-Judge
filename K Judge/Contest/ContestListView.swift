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
                Text("대회 이름").frame(width: 70, height: 50 ).onAppear(){
                    contestListViewModel.challengeList = contestListViewModel.getContestList()
                    
                }
                Spacer()
                Text("대회 시작").frame(width: 100, height: 50 )
                Spacer()
                Text("대회 종료").frame(width: 100, height: 50 )
            }.padding()
            ScrollView{
                ForEach($contestListViewModel.challengeList, id: \.id ){ item in
                    NavigationLink(destination: ContestItemView(challenge: item), label: {
                        ContestListItemView(challengeListItem:item)
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
