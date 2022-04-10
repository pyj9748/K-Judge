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
           
          
               
            ScrollView{
                ForEach($contestListViewModel.challengeList, id: \.id ){ item in
                    NavigationLink(destination: ContestItemView(challenge: item), label: {
                        ContestListItemView(challengeListItem:item)
                    })
                   
                }
            }
            Spacer().onAppear(){
                contestListViewModel.challengeList = contestListViewModel.getContestList()
                
            }
              
        }
        
    }
}



struct ContestListView_Previews: PreviewProvider {
    static var previews: some View {
        ContestListView()
    }
}
