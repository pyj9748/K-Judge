//
//  CreateViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import Foundation
import Alamofire
import SwiftyJSON

// View Model
class CreateViewModel :ObservableObject {
    
    @Published var problem = Problem( id : "" , name: "name", description: Description(description: "Enter description", input_description: "Enter input description", output_description: "Enter output description"), limit: Limit(memory: "256", time: "2"),score: "1500")
    
    @Published var input_file1 : String = """
    Enter Input File Content
    """
    
    @Published var output_file1 : String = """
    Enter Output File Content
    """
    
    @Published var input_file2 : String = """
    Enter Input File Content
    """
    
    @Published var output_file2 : String = """
    Enter Output File Content
    """
    
}


extension CreateViewModel{
    
    // /api/problems
    func createProblem() {
        let input_file_content1 = self.input_file1
        let input_file_url1 = self.getDocumentDirectory().appendingPathComponent("1.in")
        do {
            try input_file_content1.write(to:input_file_url1, atomically:true,encoding : .utf8)
            //let input1 = try String(contentsOf: input_file_url1)
           // print("input_file_content1 : \(input1)")
           // print(input_file_url1.path)
        }
        catch{
            print(error.localizedDescription)
            
        }
        let output_file_content1 = self.output_file1
        let output_file_url1 = self.getDocumentDirectory().appendingPathComponent("1.out")
        do {
            try output_file_content1.write(to:output_file_url1, atomically:true,encoding : .utf8)
            //let output1 = try String(contentsOf: output_file_url1)
            //print("output_file_content : \(output1)")
        }
        catch{
            print(error.localizedDescription)
            
        }

        let input_file_content2 = self.input_file2
        let input_file_url2 = self.getDocumentDirectory().appendingPathComponent("2.in")
        do {
            try input_file_content2.write(to:input_file_url2, atomically:true,encoding : .utf8)
            //let input2 = try String(contentsOf: input_file_url2)
           // print("input_file_content2 : \(input2)")
           // print(input_file_url2.path)
        }
        catch{
            print(error.localizedDescription)
            
        }
        let output_file_content2 = self.output_file2
        let output_file_url2 = self.getDocumentDirectory().appendingPathComponent("2.out")
        do {
            try output_file_content2.write(to:output_file_url2, atomically:true,encoding : .utf8)
            //let output2 = try String(contentsOf: output_file_url2)
           // print("output_file_content2 : \(output2)")
        }
        catch{
            print(error.localizedDescription)
            
        }
      
        uploadProblem(inputData: [input_file_url1, input_file_url2], outputData: [output_file_url1,output_file_url2])
        
        
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
}


extension CreateViewModel {
    func uploadProblem(inputData : [URL], outputData: [URL]){
        
        let json : JSON = [
            "name" : self.problem.name,
            "description" : [
                "description" : self.problem.description.description,
                "intput_description" : self.problem.description.input_description,
                "output_description" :
                    self.problem.description.output_description
            ],
            "limit" : [
                "memory" : Int(self.problem.limit.memory)!,
                "time" : Int(self.problem.limit.time)!
            ],
            "score" : self.problem.score
        ]
        
        print(json.rawString()!)
       
        
        // URL 생성
        guard let url = URL(string:"\(baseURL):8080/api/problems")
        else {
            return
        }
       
      
        // header
        let headers : HTTPHeaders = [
                    "Content-Type" : "multipart/form-data" ]
        // multipart upload
        AF.upload(multipartFormData: {
            (multipart) in
            // problem
            
            // 1. 애초에 json 전체를 스트링으로 넘긴다.
            
            // 2. post body 의 속성을 늘린다.
            multipart.append(self.problem.name.data(using: .utf8)!, withName: "name")
            multipart.append(self.problem.description.description.data(using: .utf8)!, withName: "description")
            multipart.append(self.problem.description.input_description.data(using: .utf8)!, withName: "input_description")
            multipart.append(self.problem.description.output_description.data(using: .utf8)!, withName: "output_description")
            multipart.append(self.problem.limit.memory.data(using: .utf8)!, withName: "memory")
            multipart.append(self.problem.limit.time.data(using: .utf8)!, withName: "time")
            multipart.append(self.problem.score.data(using: .utf8)!, withName: "score")
           
           
            // inputs
            for input in inputData {
                let filePathUrl = NSURL(fileURLWithPath: input.path)
                multipart.append(filePathUrl as URL, withName: "inputs", fileName: input.lastPathComponent, mimeType: "text/plain")
            }
            // outputs
            for output in outputData {
                let filePathUrl = NSURL(fileURLWithPath: output.path)
                multipart.append(filePathUrl as URL, withName: "outputs", fileName: output.lastPathComponent, mimeType: "text/plain")
            }

        },to: url,method: .post,headers: headers)
            .responseJSON(completionHandler: {
                response in
                print(response)
                if let err = response.error{
                               print(err)
                               return
                           }
                print("success")
            })

        
    }
    
}
