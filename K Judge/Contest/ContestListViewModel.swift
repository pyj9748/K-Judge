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
    
    @Published var contestList : [Contest] = []
    
    init(){
        self.contestList = getContestList()
       
    }
    
}

// api call - 대회 목록조회
extension ContestListViewModel {
    func getContestList() -> [Contest]{
        var list :[Contest] = []
        //
        // dummy
        let contest1 = Contest(id: UUID(), authors: [Author(id: UUID(), user_id: "1", name: "a1", accumulate_score: "1")], name: "contest1", challenge_date_time: Challenge_date_time(start_time: "1", end_time: "2"), questions: [1,2,3,4])
        let contest2 = Contest(id: UUID(), authors: [Author(id: UUID(), user_id: "2", name: "a2", accumulate_score: "2")], name: "contest2", challenge_date_time: Challenge_date_time(start_time: "3", end_time: "4"), questions: [1,2])
        list = [contest1,contest2]
        
       
        // api call - 대회 목록조회
        let url = "\(baseURL)/api/challenges"
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
        
        
        
        // list =
        
        return list
        
    }
    
    
    
}


        
        

