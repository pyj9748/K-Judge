//
//  SubmitViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import Foundation
import Alamofire
import SwiftyJSON


// View Model
class SubmitViewModel :ObservableObject {
    
    @Published var submit = Submit(source_code: init_codes[0], programming_language: languages[0],problem_id: 1)
    @Published var showSuccess = false
    @Published var showFail = false
    @Published var showNoID = false
}

// api call - 문제 채점 요청
extension SubmitViewModel {
    func gradeSubmitCode(problemId: Int, challengeId: Int,token: String) {
        
        let url = "\(baseURL):8080/api/challenges/\(challengeId)/participations/submits" ///////////
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                
        let headers : HTTPHeaders = [
                    "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
        
        let postSubmit = Submit(source_code: submit.source_code, programming_language: submit.programming_language, problem_id: problemId)
       

        AF.request(url,
                   method: .post,
                   parameters: postSubmit,
                   encoder: JSONParameterEncoder.default,headers: headers).response { response in
            debugPrint(response)
        }.responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
             
                if json["data"]["message"].stringValue == "successfully submit your code."{
                    self.showSuccess = true
                    return
                }
                if json["error"]["message"].stringValue == "해당 id의 참여자가 존재하지 않습니다."{
                    self.showNoID = true
                    return
                }
                
                else {
                    self.showFail = true
                    return
                }
            default:
                return
            }

        })

        
        
    }
}




let languages = [Language.JAVA.string , Language.CPP.string , Language.C.string]

let init_codes : [String] = [
    """
    public static void main(String[] args) {
    
        System.out.println("Hello World");
    
    }

    """
    ,
    
    """
    #include <iostream>

    int main()

    {
        std::cout << "Hello World\n";
        return 0;
    }
    
    """
    ,
    
    """
    #include <stdio.h>
     
    int main(void)
    {
        printf("Hello World\n");
        return 0;
    }
    
    """
]
