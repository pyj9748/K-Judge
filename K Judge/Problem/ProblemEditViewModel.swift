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
    
    @Published var problem = Problem(id: "", name: "", description: Description(description: "Enter Description", input_description: "Enter Input Description", output_description: "Enter Output Description"), limit: Limit(memory: "256", time: ""), score: "100")
    
   
    
}

// api call - 문제 수정
extension ProblemEditViewModel {
    func editProblem( parameters :  [String: Any] , problemId : String,token : String){
        
        // api call
        print(parameters)
        // URL
        guard let url = URL(string:"\(baseURL):8080/api/problems/\(problemId)")
        else {
            return
        }
        // Header
        let headers : HTTPHeaders = [
                    "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
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
