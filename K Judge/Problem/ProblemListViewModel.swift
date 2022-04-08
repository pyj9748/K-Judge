//
//  ProblemListViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import Foundation
import Alamofire
import SwiftyJSON

// View Model
class ProblemListViewModel :ObservableObject {
    
    @Published var problemList : [ProblemCatalogs] = []

    
}

// 서버에서 problem List 받아오기
extension ProblemListViewModel {
    func getProblemList(token:String) -> [ProblemCatalogs]{
        var list :[ProblemCatalogs] = []
        print("getProblemList")
        
        // api call - 문제 목록조회
        let url = URL(string: "\(baseURL):8080/api/problem_catalogs/authors")!
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
                     
                     for i in (dataList?.indices)! {
                         let data = json["data"].arrayValue[i]
                         let problem = ProblemCatalogs(id: String(data["id"].intValue), name: data["name"].stringValue, score: data["score"].stringValue)
                         list.append(problem)
                         //print(problem)
                     }
                     self.problemList = list
                 case.failure(let error) :
                     print(error.localizedDescription)
                 }
               
             })
       
        return list
        
    }
}
