//
//  ProblemEditViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/20.
//

import Foundation
import Alamofire
import SwiftyJSON

// View Model
class ProblemEditViewModel :ObservableObject {
    
    @Published var problem = Problem(id: "id", name: "name", description: Description(description: "description", input_description: "input_description", output_description: "output_description"), limit: Limit(memory: "", time: ""), score: "score")
    
   
    
}

// api call - 문제 수정
extension ProblemEditViewModel {
    func editProblem( parameters :  [String: Any] , problemId : String){
        
        // api call
        print(parameters)
        // URL
        guard let url = URL(string:"\(baseURL)/api/problems/\(problemId)")
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
