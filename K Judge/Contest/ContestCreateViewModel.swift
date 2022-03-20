//
//  ContestCreateViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import Foundation
import Alamofire
import SwiftyJSON

// View Model
class ContestCreateViewModel :ObservableObject {
    
    @Published var contest = Contest(id : "0", authors: [], name: "name", challenge_date_time: Challenge_date_time(start_time: Date(), end_time: Date() ), questions: [])
    
}

// api call - contest 생성
extension ContestCreateViewModel {
    
    func createContest( parameters :  [String: Any]){
        
        // api call
        print(parameters)
        // URL
        guard let url = URL(string:"\(baseURL)/api/challenges")
        else {
            return
        }
        // Header
        let headers : HTTPHeaders = [
                    "Content-Type" : "application/json" ]
        // Parameter
       
        // Request
        
        
        AF.request(url, method: .post , parameters: parameters , headers: headers)
        //    .responseDecodable(completionHandler: {
        //                response in
        //                print(response)
        //                if let err = response.error{
        //                               print(err)
        //                               return
        //                           }
        //                print("success")
        //            })

            
        
    }
}
