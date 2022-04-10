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
        
//            HStack{
//                Text(String(submissionListItem.problem_id))
//                Spacer()
//                Text(submissionListItem.submitted_at)
//                Spacer()
//                Text(submissionListItem.status)
//
//            }
        HStack{
            
                HStack(spacing: 20){
                    Image(systemName: "octagon")
                        .font(.largeTitle)
                        
                    
                    VStack(alignment:.leading){
                        
                        Text("문제아이디 : \(String(submissionListItem.problem_id))").foregroundColor(Color.black)
                        Text("제출시각 : \(self.editDate (str : submissionListItem.submitted_at))").foregroundColor(Color.black)
                        Text("채점결과 : \(submissionListItem.status)").foregroundColor(Color.black)
                    }
                }.padding(.horizontal)
               
            
            Spacer()
        }.padding(3)
    }
}
extension SubmissionListItem {
    func editDate(str:String) -> String {
        let startIndex1 = str.startIndex
        let endIndex1 = str.index(startIndex1, offsetBy: 9)
        var str1 = str[startIndex1...endIndex1]
        let startIndex2 = str.index(startIndex1, offsetBy: 11)
        let endIndex2 = str.index(startIndex2, offsetBy: 4)
        var str2 = str[startIndex2...endIndex2]
        str1 += " "
        str1 += str2
        return String(str1)
    }
}
struct SubmissionListItem_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionListItem(submissionListItem: .constant(Submission(id: 1, problem_id: 1, submitted_at: "mm:yy:dd", challenge_score: 1, status: "SUCCESS")))
    }
}
