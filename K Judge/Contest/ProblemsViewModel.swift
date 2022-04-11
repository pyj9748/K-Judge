//
//  ProblemsViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import Foundation
import SwiftyJSON
import Alamofire

// View Model
class ProblemsViewModel :ObservableObject {
    
    @Published var challengeProblemList: [ChallengeProblem] = []
    
    
    
}

// api call - 문제 목록 조회
extension ProblemsViewModel {
    func getProblemList(challengeId : Int){
        var list :[ChallengeProblem] = []
        print("getChallengeProblemList", challengeId)
        
        // api call - 문제 목록조회
        let url = URL(string: "\(baseURL):8080/api/challenges/\(challengeId)/questions")!
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
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
          
             .responseJSON(completionHandler: { response in
                 //여기서 가져온 데이터를 자유롭게 활용하세요.
                 switch response.result{
                 case.success(let value):
                     print(response)
                     let json = JSON(value)
                     // let dataList = json["data"].array
                     guard let dataList = json["data"].array else {return}
                     
                     for i in (dataList.indices) {
                         let data = json["data"].arrayValue[i]
                         let problem = ChallengeProblem(id: data["id"].intValue, problem_id: data["problem_id"].intValue, title: data["title"].stringValue,challeng_id: challengeId)
                         list.append(problem)
                         
                     }
                     self.challengeProblemList = list
                     self.challengeProblemList.sort(by: {
                             return $0.problem_id < $1.problem_id
                             
                         })
                     print(self.challengeProblemList)
                 case.failure(let error) :
                     print(error.localizedDescription)
                 }
               
             })
        
    }
}

struct ChallengeProblem:Identifiable {
    let id : Int
    var problem_id : Int
    let title: String
    var challeng_id : Int
}
