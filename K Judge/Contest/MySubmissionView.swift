//
//  MySubmissionView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

struct MySubmissionView: View {
    @Binding var contest : Contest
    var body: some View {
        Text("my submission view")
    }
}

struct MySubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        MySubmissionView(contest: .constant(Contest(id: "1", authors: [Author( user_id: "1", name: "a1", accumulate_score: "1")], name: "contest1", challenge_date_time: Challenge_date_time(start_time: Date(), end_time: Date()), questions: [1,2,3,4])))
    }
}
