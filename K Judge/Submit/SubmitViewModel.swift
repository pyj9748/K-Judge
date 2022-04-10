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
        }

        
        
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
