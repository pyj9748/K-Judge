//
//  ProblemItemView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ProblemItemView: View {
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @Binding var problemId : String
    @StateObject var problemItemViewModel = ProblemItemViewModel()
    
    var body: some View {
        HStack {
            
            VStack(alignment : .leading){
                ScrollView{
                    VStack(alignment : .leading){
                        Text("").onAppear(){
                            print("ProblemItemView \(problemId)")
                            problemItemViewModel.problem = problemItemViewModel.getProblem(problemId: self.problemId,token: token)
                        }
                        
                            nameText
                            descriptionText
                            input_descriptionText
                            output_descriptionText
                            scoreText
                        
                       
                        
                    }
                }
               .padding()
               .navigationBarTitle("문제 생성",displayMode:.inline)
               .toolbar(content: {
                   editBtn
               })
            }
            Spacer()
        }
        
       
    }
}
// 문제 수정 뷰 이동 버튼
extension ProblemItemView {
  
    var editBtn : some View {
        NavigationLink(destination: ProblemEditView(problemId: $problemId), label: {
            HStack {
                    Image(systemName: "pencil.circle")
                    .font(.body)
                    Text("  수정  ")
                        .fontWeight(.semibold)
                        .font(.body
                        )
                }
                .padding(10)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        })
    }
}
extension ProblemItemView {
    
    // Name
    var nameText: some View{
        VStack(alignment:.leading){
            Text("문제 이름").font(.headline)
            Text(" ")
            Text(problemItemViewModel.problem.name )
                .textFieldStyle(.roundedBorder)
               // .padding()
                //.background(Color.gray)
            Text(" ")
        }
    }
    
    // Description
    var descriptionText : some View{
        VStack(alignment:.leading){
            Text("문제").font(.headline)
            Text(" ")
            Text(problemItemViewModel.problem.description.description)
            Text(" ")
        }
    }
   
    // input_description
    var input_descriptionText : some View{
        VStack(alignment:.leading){
            Text("입력").font(.headline)
            Text(" ")
            Text(problemItemViewModel.problem.description.input_description)
            Text(" ")
        }
    }
   
    // output_description
    var output_descriptionText: some View{
        VStack(alignment:.leading){
            Text("출력").font(.headline)
            Text(" ")
            Text(problemItemViewModel.problem.description.output_description)
            Text(" ")
        }
    }

    // score
    var scoreText : some View{
        VStack(alignment:.leading){
            Text("점수").font(.headline)
            Text(" ")
            Text(problemItemViewModel.problem.score)
                .textFieldStyle(.roundedBorder)
            Text(" ")
        }
    }
    
    
}



















// View Model

class ProblemItemViewModel :ObservableObject {
    
    @Published var problem = Problem(id: "id", name: "name", description: Description(description: "description", input_description: "input_description", output_description: "output_description"), limit: Limit(memory: "", time: ""), score: "score")
   
}

// api call - 문제 상세 조회
extension ProblemItemViewModel {
    
    func getProblem(problemId: String, token:String)-> Problem {
        let url = "\(baseURL):8080/api/problem_catalogs/\(problemId)"
        var problemDetail = Problem(id: "", name: "", description: Description(description: "", input_description: "", output_description: ""), limit: Limit(memory: "", time: ""), score: "")
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json","Authorization": "Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                //여기서 가져온 데이터를 자유롭게 활용하세요.
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let data = json["data"]
                    problemDetail = Problem(id : String(data["id"].intValue), name:data["name"].stringValue , description: Description(description: data["description"].stringValue, input_description: data["input_description"].stringValue, output_description: data["output_description"].stringValue), limit: Limit(memory: "", time: ""), score: data["score"].stringValue)
                    self.problem = problemDetail
                    
                case.failure(let error) :
                    print(error.localizedDescription)
                }
               
            })
        return problemDetail
    }
  
}




struct ProblemItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemItemView(problemId: .constant("1"))
    }
}
