//
//  ContestView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

struct ContestView: View {
    @StateObject var contestViewModel = ContestViewModel()

    @State var tabIndex = 0
    
    var body: some View {
        NavigationView{
            VStack(alignment : .leading){
                ContestCustomTopTabBar(tabIndex: $tabIndex)
                if tabIndex == 0 {
                   ContestListView()
                }
                else  {
                    ContestCreateView()
                }          
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
            .padding(.horizontal, 12)
            .navigationBarTitle(" 대회 " ,displayMode:.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: UserInfoView(), label: {
                       
                            Image(systemName: "person.crop.circle")
                            .font(.body)
                        
                        
                    })
                    
                }
               
            })
        }
    }
    
}
struct ContestCustomTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 20) {
            TabBarButton(text: "대회 목록", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            TabBarButton(text: "대회 생성", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
          
           
            Spacer()
        }
        .border(width: 1, edges: [.bottom], color: Color("DefaultTextColor"))
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}
struct ContestView_Previews: PreviewProvider {
    static var previews: some View {
        ContestView()
    }
}
