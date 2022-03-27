//
//  ProblemDetailView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/20.
//

import SwiftUI
import SwiftyJSON
import Alamofire

struct ProblemDetailView: View {
    @Binding var challenge: ChallengeProblem
    @StateObject var problemDetailViewModel =  ProblemDetailViewModel()
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    
                    nameText.onAppear(){
                        problemDetailViewModel.problem = problemDetailViewModel.getProblem(problemId: challenge.problem_id)
                    }
                    descriptionText
                    input_descriptionText
                    output_descriptionText
                    scoreText
                }.padding()
            } .navigationBarTitle(challenge.title,displayMode:.inline)
        } .navigationBarTitle("Submit",displayMode:.inline)
            .toolbar(content: {
                submitBtn
            })
    }
}


extension ProblemDetailView {
    
    // Name
    var nameText: some View{
        GroupBox("Name"){
            Text( $problemDetailViewModel.problem.name.wrappedValue )
                .textFieldStyle(.roundedBorder)
        }
    }

    // Description
    var descriptionText : some View{
        GroupBox("Description"){
            Text($problemDetailViewModel.problem.description.wrappedValue)
        }
    }

    // input_description
    var input_descriptionText : some View{
        GroupBox("InPut Description"){
            Text($problemDetailViewModel.problem.input_description.wrappedValue)
        }
    }

    // output_description
    var output_descriptionText: some View{
        GroupBox("OutPut Description"){
            Text($problemDetailViewModel.problem.output_description.wrappedValue)
        }
    }

    // score
    var scoreText : some View{
        GroupBox("Score"){
            Text(String($problemDetailViewModel.problem.score.wrappedValue))
                .textFieldStyle(.roundedBorder)
        }
    }
    
    
}


struct ProblemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemDetailView(challenge: .constant(ChallengeProblem(id: 1, problem_id: 1, title: "ads")))
    }
}


// View Model
class ProblemDetailViewModel :ObservableObject {
    
    @Published var problem = ProblemDetail(id: 0, name: "", description: "", input_description: "", output_description: "", score: 0)
    
  
}

struct ProblemDetail {
    let id : Int
    var name : String
    var description : String
    var input_description : String
    var output_description :String
    var score : Int
    
}
// api call - 문제 상세 조회
extension ProblemDetailViewModel{
    
    func getProblem(problemId: Int)-> ProblemDetail {
        print(" get Problem : \(problemId)")
        let url = "\(baseURL):8081/api/problem_catalogs/\(problemId)"
        var problemDetail = ProblemDetail(id: 0, name: "", description: "", input_description: "", output_description: "", score: 0)
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
                    print(response)
                    let json = JSON(value)
                    let data = json["data"]
                    problemDetail = ProblemDetail(id: data["id"].intValue, name: data["name"].stringValue, description: data["description"].stringValue, input_description: data["input_description"].stringValue, output_description: data["output_description"].stringValue, score: data["score"].intValue)
                    self.problem = problemDetail
                 
                case.failure(let error) :
                    print(error.localizedDescription)
                }
               
            })
        return problemDetail
    }
  
}

// 문제 수정 뷰 이동 버튼
extension ProblemDetailView {
  
    var submitBtn : some View {
        NavigationLink(destination: SubmitView(problemDetail: $problemDetailViewModel.problem), label: {
            HStack {
                    Image(systemName: "envelope")
                    .font(.body)
                    Text("Submit")
                        .fontWeight(.semibold)
                        .font(.body
                        )
                }
                .padding(6)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        })
    }
    
    
}
