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
    
    init(){
        self.problemList = getProblemList()
       
    }
    
}

// 서버에서 problem List 받아오기
extension ProblemListViewModel {
    func getProblemList() -> [ProblemCatalogs]{
        var list :[ProblemCatalogs] = []
        //
        // dummy
        let problem1 = ProblemCatalogs(id: "1", name: "problem1", score: "100")
        let problem2 = ProblemCatalogs(id: "2", name: "problem2", score: "200")
        let problem3 = ProblemCatalogs(id: "3", name: "problem3", score: "200")
        let problem4 = ProblemCatalogs(id: "4", name: "problem4", score: "200")
        let problem5 = ProblemCatalogs(id: "5", name: "problem5", score: "200")
        let problem6 = ProblemCatalogs(id: "6", name: "problem6", score: "200")
        let problem7 = ProblemCatalogs(id: "7", name: "problem7", score: "200")
        list = [problem1,problem2,problem3,problem4,problem5,problem6,problem7]
        
        // api call - 문제 목록조회
        let url = URL(string: "\(baseURL)/api/problem_catalogs")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
          
             .responseJSON(completionHandler: { response in
                 //여기서 가져온 데이터를 자유롭게 활용하세요.
                 switch response.result{
                 case.success(let value):
                     let json = JSON(value)
                     let dataList = json["data"].array
                     for i in (dataList?.indices)! {
                         let data = json["data"].arrayValue[i]
                         let problem = ProblemCatalogs(id: String(data["id"].intValue), name: data["name"].stringValue, score: data["score"].stringValue)
                         list.append(problem)
                     }
                 case.failure(let error) :
                     print(error.localizedDescription)
                 }
               
             })
        
        return list
        
    }
}
