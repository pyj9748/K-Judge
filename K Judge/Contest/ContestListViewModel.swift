//
//  ContestListViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import Foundation
import Alamofire
import SwiftyJSON

// View Model
class ContestListViewModel :ObservableObject {
    
    @Published var challengeList : [Challenge] = []
    
    
}



// api call - 대회 목록조회
extension ContestListViewModel {
    func getContestList() -> [Challenge]{
        var list :[Challenge] = []
        let parameters : [String: Any] = [
                       "page":  2,
                       //"size": 300  // 여기는 한번에 가져올 문제 개수 값
        ]
        // api call - 대회 목록조회
        let url = "\(baseURL):8080/api/challenges"
               AF.request(url,
                          method: .get,
                          parameters:parameters,
                      
                          encoding: URLEncoding.default,
                          headers: ["Content-Type":"application/json", "Accept":"application/json"])
                   .validate(statusCode: 200..<300)
                   .responseJSON { response in
                       //여기서 가져온 데이터를 자유롭게 활용하세요.
                       switch response.result{
                       case.success(let value):
                           print(response)
                           let json = JSON(value)
                         
                           guard let dataList = json["data"].array else {return}
                           
                           
                           for i in (dataList.indices) {
                               let data = json["data"].arrayValue[i]
                            
                               let challenge = Challenge(id: data["id"].intValue, name: data["name"].stringValue, start_time: data["challenge_date_time"]["start_time"].stringValue,  end_time: data["challenge_date_time"]["end_time"].stringValue, num_of_participation: data["num_of_participation"].intValue, num_of_question: data["num_of_question"].intValue)
                               
                               list.append(challenge)
                           }
                           
                           self.challengeList = list
                           print(self.challengeList)
                       case.failure(let error) :
                           print(error.localizedDescription)
                       }
               }
        return list
        
    }
    
    
    
}


        
        




