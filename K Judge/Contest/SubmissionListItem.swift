//
//  SubmissionListItem.swift
//  K Judge
//
//  Created by young june Park on 2022/04/04.
//

import SwiftUI

struct SubmissionListItem: View {
    
    @Binding var submissionListItem : Submission
    var body: some View {
        GroupBox{
            HStack{
                Text(String(submissionListItem.problem_id))
                Spacer()
                Text(submissionListItem.submitted_at)
                Spacer()
                Text(submissionListItem.status)
                
            }
        }
    }
}

struct SubmissionListItem_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionListItem(submissionListItem: .constant(Submission(id: 1, problem_id: 1, submitted_at: "mm:yy:dd", challenge_score: 1, status: "SUCCESS")))
    }
}
