//
//  SubmissionDetailView.swift
//  K Judge
//
//  Created by young june Park on 2022/04/04.
//

import SwiftUI
import SwiftyJSON
import Alamofire

struct SubmissionDetailView: View {
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @Binding var challengeId: Int
    @Binding var submissionId: Int
  
    
    @StateObject var submissionDetailViewModel =  SubmissionDetailViewModel()
    var body: some View {
        HStack{
            
            VStack(alignment : .leading){
                ScrollView{
                    VStack(alignment : .leading){
                        Text("").onAppear(){
                            //guard submissionID != nil else {return}
                          //  print(submissionID)
                         //   let submitID = submissionID
                            //guard submissionId != nil else {return}
                            print("submissionId : \(submissionId )")
                            submissionDetailViewModel.submissionDetail = submissionDetailViewModel.getSubmission(challengeId: challengeId, submitId: submissionId, token: token)
                            
                        }
                        problemIDText
                        programmingLanguageText
                        sourceCodeText
                    }.padding()
                } .navigationBarTitle("",displayMode:.inline)
                Spacer()
            }
            
        }
        
    }
}


extension SubmissionDetailView {
    
    // problemID
    var problemIDText: some View{
        VStack(alignment:.leading){
            Text("문제 아이디").font(.headline)
            Text(" ")
            Text(String($submissionDetailViewModel.submissionDetail.problem_id.wrappedValue) )
            Text(" ")
                
        }
    }

    // programmingLanguage
    var programmingLanguageText : some View{
        VStack(alignment:.leading){
            Text("프로그래밍 언어").font(.headline)
            Text(" ")
            Text($submissionDetailViewModel.submissionDetail.programming_language .wrappedValue)
            Text(" ")
        }
    }

    // isourceCode
    var sourceCodeText : some View{
        VStack(alignment:.leading){
            Text("소스 코드").font(.headline)
            Text(" ")
            Text($submissionDetailViewModel.submissionDetail.source_code .wrappedValue)
            Text(" ")
        }
    }

  
    
    
}


struct SubmissionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionDetailView(challengeId: .constant(1),submissionId: .constant(1))
    }
}


// View Model
class SubmissionDetailViewModel :ObservableObject {
    
    @Published var submissionDetail = SubmissionDetail(id: 1, problem_id: 1, programming_language: "CPP", source_code: "#include <stdio.h>\n#include <stdlib.h>\n\nint main() {\n\tint n, m, i, j;\n\tscanf(\"%d %d\", &n, &m); //n행 m....")
    
  
}

struct SubmissionDetail : Encodable {
    var id : Int
    var problem_id : Int
 
    var programming_language : String
    var source_code :String
   
    
}
// api call - 문제 상세 조회
extension SubmissionDetailViewModel{
    
    func getSubmission(challengeId:Int, submitId:Int ,token : String) -> SubmissionDetail{
        print(" get Submission : \(submitId)")
        let url = "\(baseURL):8080/api/challenges/\(challengeId)/participations/submits/\(submitId)"
        //var subDetail = SubmissionDetail(id: 1, problem_id: 1, programming_language: "", source_code: "")
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                //여기서 가져온 데이터를 자유롭게 활용하세요.
                switch response.result{
                case.success(let value):
                    print(response)
                    let json = JSON(value)
                    let data = json["data"]
                    
                    self.submissionDetail.id = data["id"].intValue
                    self.submissionDetail.problem_id = data["problem_id"].intValue
                    self.submissionDetail.programming_language = data["programming_language"].stringValue
                    self.submissionDetail.source_code = data["source_code"].stringValue
                    
                  
                    
                 
                case.failure(let error) :
                    print(error.localizedDescription)
                }
               
            })
        return self.submissionDetail
    }
  
}



