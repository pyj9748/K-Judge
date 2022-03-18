//
//  ProblemItemView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ProblemItemView: View {
    
    @Binding var problemId : String
    
    
    var body: some View {
        Text(problemId).onAppear(){
            
        }
    }
}

// api call - 문제 상세 조회
extension ProblemItemView {
    
    func getProblemDetail() {
        let url = "\(baseURL)/api/problem_catalogs/\(self.problemId)"
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { (json) in
                //여기서 가져온 데이터를 자유롭게 활용하세요.
                print(json)
                
        }
    }
  
}


struct ProblemItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemItemView(problemId: .constant("1"))
    }
}
