//
//  MySubmissionViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import Foundation
import Alamofire
import SwiftyJSON
// View Model
class MySubmissionViewModel :ObservableObject {
    
    @Published var submissionList: [Submission] = []
    
}

// api call - 문제 목록 조회
extension MySubmissionViewModel {
    func getSubmissionList(challengeId : Int, token : String) -> [Submission]{
        var list :[Submission] = []
        print("getSubmissionList", challengeId)
      
        // api call - 문제 목록조회
        let url = URL(string: "\(baseURL):8080/api/challenges/\(challengeId)/participations/submits")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let parameters : [String: Any] = [
                       "page": 0,
                       "size": 300  // 여기는 한번에 가져올 문제 개수 값
                   ]
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json","Authorization": "Bearer \(token)"])
          
             .responseJSON(completionHandler: { response in
                 //여기서 가져온 데이터를 자유롭게 활용하세요.
                 switch response.result{
                 case.success(let value):
                     //print(response)
                     let json = JSON(value)
                     let dataList = json["data"].array
                     guard (json["data"].count) > 0 else {return}
                     for i in (dataList?.indices)! {
                         let data = json["data"].arrayValue[i]
                         let submission = Submission(id: data["id"].intValue, problem_id: data["problem_id"].intValue, submitted_at: data["submitted_at"].stringValue,challenge_score: data["challenge_score"].intValue, status: data["status"].stringValue)
                         list.append(submission)
                         
                     }
                     self.submissionList = list
                    self.submissionList.sort(by: {
                         return $0.submitted_at > $1.submitted_at
                     })
                 case.failure(let error) :
                     print(error.localizedDescription, "sdafasdf")
                 }
               
             })
       
        return list
        
    }
}

struct Submission :Encodable ,Identifiable{
    var id : Int
    var problem_id : Int
    var submitted_at : String
    var challenge_score : Int
    var status : String
    
    
}
