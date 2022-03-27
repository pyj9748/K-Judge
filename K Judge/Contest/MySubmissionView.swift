//
//  MySubmissionView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

struct MySubmissionView: View {
    @Binding var challenge : Challenge
    var body: some View {
        Text("my submission view")
    }
}

struct MySubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        MySubmissionView(challenge: .constant(Challenge(id: 1, name: "name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)))
    }
}
