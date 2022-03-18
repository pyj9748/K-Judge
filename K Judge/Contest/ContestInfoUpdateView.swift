//
//  ContestInfoUpdateView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI

struct ContestInfoUpdateView: View {
    var body: some View {
       
        VStack{
            //NavigationLink()
            Text("a")
        }
       
        
    }
}

// 정보 수정
extension ContestInfoUpdateView{
    var infoUpdate : some View{
        Text("info Update")
    }
}

// 출제자 수정
extension ContestInfoUpdateView{
    var authorUpdate : some View{
        Text("author Update")
    }
}
// 문제 수정
extension ContestInfoUpdateView{
    var questionsUpdate : some View{
        Text("questions Update")
    }
}
struct ContestInfoUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ContestInfoUpdateView()
    }
}
