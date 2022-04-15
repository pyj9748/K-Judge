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
    
    @Published var problem = Problem( id : "" , name: "", description: Description(description: "Enter description", input_description: "Enter input description", output_description: "Enter output description"), limit: Limit(memory: "256", time: "2"),score: "1500")
    
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
    @Published var input_file3 : String = """
    Enter Input File Content
    """
    
    @Published var output_file3 : String = """
    Enter Output File Content
    """
    
    @Published var input_file4 : String = """
    Enter Input File Content
    """
    
    @Published var output_file4 : String = """
    Enter Output File Content
    """
    @Published var input_file5 : String = """
    Enter Input File Content
    """
    
    @Published var output_file5 : String = """
    Enter Output File Content
    """
    
    @Published var input_file6 : String = """
    Enter Input File Content
    """
    
    @Published var output_file6 : String = """
    Enter Output File Content
    """
    @Published var input_file7 : String = """
    Enter Input File Content
    """
    
    @Published var output_file7 : String = """
    Enter Output File Content
    """
    
    @Published var input_file8 : String = """
    Enter Input File Content
    """
    
    @Published var output_file8 : String = """
    Enter Output File Content
    """
    
}


extension CreateViewModel{
    
    // /api/problems
    func createProblem(token : String , testCaseNum : Int) {
        let input_file_content1 = self.input_file1
        let input_file_url1 = self.getDocumentDirectory().appendingPathComponent("1.in")
        do {
            try input_file_content1.write(to:input_file_url1, atomically:true,encoding : .utf8)
           
        }
        catch{
            print(error.localizedDescription)
            
        }
        let output_file_content1 = self.output_file1
        let output_file_url1 = self.getDocumentDirectory().appendingPathComponent("1.out")
        do {
            try output_file_content1.write(to:output_file_url1, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
            
        }

        let input_file_content2 = self.input_file2
        let input_file_url2 = self.getDocumentDirectory().appendingPathComponent("2.in")
        do {
            try input_file_content2.write(to:input_file_url2, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
            
        }
        let output_file_content2 = self.output_file2
        let output_file_url2 = self.getDocumentDirectory().appendingPathComponent("2.out")
        do {
            try output_file_content2.write(to:output_file_url2, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
            
        }
        
        let input_file_content3 = self.input_file3
        let input_file_url3 = self.getDocumentDirectory().appendingPathComponent("3.in")
        do {
            try input_file_content3.write(to:input_file_url3, atomically:true,encoding : .utf8)
         
        }
        catch{
            print(error.localizedDescription)
            
        }
        let output_file_content3 = self.output_file3
        let output_file_url3 = self.getDocumentDirectory().appendingPathComponent("3.out")
        do {
            try output_file_content3.write(to:output_file_url3, atomically:true,encoding : .utf8)
         
        }
        catch{
            print(error.localizedDescription)
            
        }
        let input_file_content4 = self.input_file4
        let input_file_url4 = self.getDocumentDirectory().appendingPathComponent("4.in")
        do {
            try input_file_content4.write(to:input_file_url4, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        let output_file_content4 = self.output_file4
        let output_file_url4 = self.getDocumentDirectory().appendingPathComponent("4.out")
        do {
            try output_file_content4.write(to:output_file_url4, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        
        let input_file_content5 = self.input_file5
        let input_file_url5 = self.getDocumentDirectory().appendingPathComponent("5.in")
        do {
            try input_file_content5.write(to:input_file_url5, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        let output_file_content5 = self.output_file5
        let output_file_url5 = self.getDocumentDirectory().appendingPathComponent("5.out")
        do {
            try output_file_content5.write(to:output_file_url5, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        let input_file_content6 = self.input_file6
        let input_file_url6 = self.getDocumentDirectory().appendingPathComponent("6.in")
        do {
            try input_file_content6.write(to:input_file_url6, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        let output_file_content6 = self.output_file6
        let output_file_url6 = self.getDocumentDirectory().appendingPathComponent("6.out")
        do {
            try output_file_content6.write(to:output_file_url6, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        let input_file_content7 = self.input_file7
        let input_file_url7 = self.getDocumentDirectory().appendingPathComponent("7.in")
        do {
            try input_file_content7.write(to:input_file_url7, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        let output_file_content7 = self.output_file7
        let output_file_url7 = self.getDocumentDirectory().appendingPathComponent("7.out")
        do {
            try output_file_content7.write(to:output_file_url7, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        let input_file_content8 = self.input_file8
        let input_file_url8 = self.getDocumentDirectory().appendingPathComponent("8.in")
        do {
            try input_file_content8.write(to:input_file_url8, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        let output_file_content8 = self.output_file8
        let output_file_url8 = self.getDocumentDirectory().appendingPathComponent("8.out")
        do {
            try output_file_content8.write(to:output_file_url8, atomically:true,encoding : .utf8)
        }
        catch{
            print(error.localizedDescription)
        }
        
        uploadProblem(inputData: [input_file_url1, input_file_url2, input_file_url3, input_file_url4, input_file_url5, input_file_url6, input_file_url7, input_file_url8], outputData: [output_file_url1,output_file_url2,output_file_url3,output_file_url4,output_file_url5,output_file_url6,output_file_url7,output_file_url8],token: token, testCaseNum: testCaseNum)
        
        
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
}


extension CreateViewModel {
    func uploadProblem(inputData : [URL], outputData: [URL] , token :String , testCaseNum : Int){
        
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
                    "Content-Type" : "multipart/form-data","Authorization": "Bearer \(token)" ]
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
           
            //print("제출된 테스트 케이스는 \(testCaseNum)개 입니다.")
            // inputs
            for i in 0..<testCaseNum {
                let input = inputData[i]
                let filePathUrl = NSURL(fileURLWithPath: input.path)
                multipart.append(filePathUrl as URL, withName: "inputs", fileName: input.lastPathComponent, mimeType: "text/plain")
            }
//            for input in inputData {
//                let filePathUrl = NSURL(fileURLWithPath: input.path)
//                multipart.append(filePathUrl as URL, withName: "inputs", fileName: input.lastPathComponent, mimeType: "text/plain")
//            }
            // outputs
            for i in 0..<testCaseNum {
                let output = outputData[i]
                let filePathUrl = NSURL(fileURLWithPath: output.path)
                multipart.append(filePathUrl as URL, withName: "outputs", fileName: output.lastPathComponent, mimeType: "text/plain")
            }
//            for output in outputData {
//                let filePathUrl = NSURL(fileURLWithPath: output.path)
//                multipart.append(filePathUrl as URL, withName: "outputs", fileName: output.lastPathComponent, mimeType: "text/plain")
//            }

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
