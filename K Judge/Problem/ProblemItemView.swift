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
   
    @Binding var problemId : String
    @StateObject var problemItemViewModel = ProblemItemViewModel()
    
    var body: some View {
        ScrollView{
            VStack{
                Text("").onAppear(){
                    print("ProblemItemView \(problemId)")
                    problemItemViewModel.problem = problemItemViewModel.getProblem(problemId: self.problemId)
                }
                nameText
                descriptionText
                input_descriptionText
                output_descriptionText
                scoreText
                
            }
        }
       .padding()
       .navigationBarTitle("Create Problem",displayMode:.inline)
       .toolbar(content: {
           editBtn
       })
    }
}
// 문제 수정 뷰 이동 버튼
extension ProblemItemView {
  
    var editBtn : some View {
        NavigationLink(destination: ProblemEditView(problemId: $problemId), label: {
            HStack {
                   // Image(systemName: "plus.circle")
                    //.font(.body)
                    Text("  Edit  ")
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
        GroupBox("Name"){
            Text(problemItemViewModel.problem.name )
                .textFieldStyle(.roundedBorder)
        }
    }
    
    // Description
    var descriptionText : some View{
        GroupBox("Description"){
            Text(problemItemViewModel.problem.description.description)
        }
    }
   
    // input_description
    var input_descriptionText : some View{
        GroupBox("InPut Description"){
            Text(problemItemViewModel.problem.description.input_description)
        }
    }
   
    // output_description
    var output_descriptionText: some View{
        GroupBox("OutPut Description"){
            Text(problemItemViewModel.problem.description.output_description)
        }
    }

    // score
    var scoreText : some View{
        GroupBox("Score"){
            Text(problemItemViewModel.problem.score)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    
}



















// View Model

class ProblemItemViewModel :ObservableObject {
    
    @Published var problem = Problem(id: "id", name: "name", description: Description(description: "description", input_description: "input_description", output_description: "output_description"), limit: Limit(memory: "", time: ""), score: "score")
   
}

// api call - 문제 상세 조회
extension ProblemItemViewModel {
    
    func getProblem(problemId: String)-> Problem {
        let url = "\(baseURL)/api/problem_catalogs/\(problemId)"
        var problemDetail = Problem(id: "", name: "", description: Description(description: "", input_description: "", output_description: ""), limit: Limit(memory: "", time: ""), score: "")
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                //여기서 가져온 데이터를 자유롭게 활용하세요.
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let data = json["data"].arrayValue[0]
                    problemDetail = Problem(id : String(data["id"].intValue), name:data["name"].stringValue , description: Description(description: data["description"].stringValue, input_description: data["input_description"].stringValue, output_description: data["output_description"].stringValue), limit: Limit(memory: "", time: ""), score: data["score"].stringValue)
                    print(json)
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
