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
    
    @Published var problemList: [Problem] = []
    
    
    
}

// api call - 문제 목록 조회
extension ProblemsViewModel {
    func getProblemList(problems : [Int]) -> [Problem]{
        var list  = [Problem]()
        for i in problems {
            let newProblem = getProblem(id: i)
            list.append(newProblem)
        }
        
        
        return list
    }
    
    func getProblem(id : Int) -> Problem {
        let url = "\(baseURL)/api/problem_catalogs/\(id)"
        var newProblem  = Problem(id: "1", name: "", description: Description(description: "", input_description: "", output_description: ""), limit: Limit(memory: "", time: ""), score: "")
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                //여기서 가져온 데이터를 자유롭게 활용하세요.
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let data = json["data"].arrayValue[0]
                    newProblem = Problem(id : String(data["id"].intValue), name:data["name"].stringValue , description: Description(description: data["description"].stringValue, input_description: data["input_description"].stringValue, output_description: data["output_description"].stringValue), limit: Limit(memory: "", time: ""), score: data["score"].stringValue)
                    print(json)
                case.failure(let error) :
                    print(error.localizedDescription)
                }
               
            })
        return newProblem
    }
    
    
    func getProblem(problemId: String)-> Problem {
        let url = "\(baseURL)/api/problem_catalogs/\(problemId)"
        var problemDetail = Problem(id: "", name: "", description: Description(description: "", input_description: "", output_description: ""), limit: Limit(memory: "", time: ""), score: "")
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                //여기서 가져온 데이터를 자유롭게 활용하세요.
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let data = json["data"].arrayValue[0]
                    problemDetail = Problem(id : String(data["id"].intValue), name:data["name"].stringValue , description: Description(description: data["description"].stringValue, input_description: data["input_description"].stringValue, output_description: data["output_description"].stringValue), limit: Limit(memory: "", time: ""), score: data["score"].stringValue)
                    print(json)
                case.failure(let error) :
                    print(error.localizedDescription)
                }
               
            })
        return problemDetail
    }
}
