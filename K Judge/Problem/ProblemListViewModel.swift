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
        let url = "\(baseURL)/api/problem_catalogs"
               AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: ["Content-Type":"application/json", "Accept":"application/json"])
                   .validate(statusCode: 200..<300)
                   .responseJSON { (json) in
                       //여기서 가져온 데이터를 자유롭게 활용하세요.
                       print(json)
                       // list =
               }
        return list
        
    }
}
