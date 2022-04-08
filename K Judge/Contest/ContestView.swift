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
            VStack{
                ContestCustomTopTabBar(tabIndex: $tabIndex)
                if tabIndex == 0 {
                   ContestListView()
                }
                else  {
                    ContestCreateView()
                }
//                else {
//                   ContestInfoUpdateView()
//                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
            .padding(.horizontal, 12)
            .navigationBarTitle(" 대회 " ,displayMode:.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("계정 정보")
                        
                    }) {
                        Image(systemName: "person.crop.circle")
                        .font(.body)
                    }
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
        .border(width: 1, edges: [.bottom], color: .black)
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
