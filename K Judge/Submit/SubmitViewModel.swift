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
    
    @Published var submit = Submit(source_code: init_codes[0], programming_language: languages[0])
    
    
}

// api call - 문제 채점 요청
extension SubmitViewModel {
    func gradeSubmitCode() {
        
        let url = "\(baseURL)/api/problems/" ///////////
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 10
                
                // POST 로 보낼 정보
        let params = ["source_code":submit.source_code, "programming_language":submit.programming_language] as Dictionary

                // httpBody 에 parameters 추가
                do {
                    try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                } catch {
                    print("http Body Error")
                }
                
                AF.request(request).responseString { (response) in
                    switch response.result {
                    case .success:
                        print("POST 성공")
                    case .failure(let error):
                        print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    }
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
