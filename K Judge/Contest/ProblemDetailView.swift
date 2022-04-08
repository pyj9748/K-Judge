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
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @Binding var challenge: ChallengeProblem
    @StateObject var problemDetailViewModel =  ProblemDetailViewModel()
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    
                    nameText.onAppear(){
                        print("problemDetailView",challenge.challeng_id,challenge.problem_id)
                        problemDetailViewModel.problem = problemDetailViewModel.getProblem(problemId: challenge.problem_id,token: token)
                    }
                    descriptionText
                    input_descriptionText
                    output_descriptionText
                    scoreText
                }.padding()
            } .navigationBarTitle(challenge.title,displayMode:.inline)
        } .navigationBarTitle(" 제출 ",displayMode:.inline)
            .toolbar(content: {
                submitBtn
            })
    }
}


extension ProblemDetailView {
    
    // Name
    var nameText: some View{
        GroupBox("문제 이름"){
            Text( $problemDetailViewModel.problem.name.wrappedValue )
                .textFieldStyle(.roundedBorder)
        }
    }

    // Description
    var descriptionText : some View{
        GroupBox("문제"){
            Text($problemDetailViewModel.problem.description.wrappedValue)
        }
    }

    // input_description
    var input_descriptionText : some View{
        GroupBox("입력"){
            Text($problemDetailViewModel.problem.input_description.wrappedValue)
        }
    }

    // output_description
    var output_descriptionText: some View{
        GroupBox("출력"){
            Text($problemDetailViewModel.problem.output_description.wrappedValue)
        }
    }

    // score
    var scoreText : some View{
        GroupBox("점수"){
            Text(String($problemDetailViewModel.problem.score.wrappedValue))
                .textFieldStyle(.roundedBorder)
        }
    }
    
    
}


struct ProblemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemDetailView(challenge: .constant(ChallengeProblem(id: 1, problem_id: 1, title: "ads",challeng_id: 1)))
    }
}


// View Model
class ProblemDetailViewModel :ObservableObject {
    
    @Published var problem = ProblemDetail(id: 0, name: "", description: "", input_description: "", output_description: "", score: 0)
    
  
}

struct ProblemDetail {
    var id : Int
    var name : String
    var description : String
    var input_description : String
    var output_description :String
    var score : Int
    
}
// api call - 문제 상세 조회
extension ProblemDetailViewModel{
    
    func getProblem(problemId: Int , token : String)-> ProblemDetail {
        print(" get Problem : \(problemId)")
        let url = "\(baseURL):8080/api/problem_catalogs/\(problemId)"
        var problemDetail = ProblemDetail(id: 0, name: "", description: "", input_description: "", output_description: "", score: 0)
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
//                    problemDetail = ProblemDetail(id: data["id"].intValue, name: data["name"].stringValue, description: data["description"].stringValue, input_description: data["input_description"].stringValue, output_description: data["output_description"].stringValue, score: data["score"].intValue)
                    
                    self.problem.id = data["id"].intValue
                    self.problem.name = data["name"].stringValue
                    self.problem.description = data["description"].stringValue
                    self.problem.input_description = data["input_description"].stringValue
                    self.problem.output_description = data["output_description"].stringValue
                    self.problem.score = data["score"].intValue
                 
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
        NavigationLink(destination: SubmitView(challenge_id: $challenge.challeng_id, problemDetail: $problemDetailViewModel.problem), label: {
            HStack {
                    Image(systemName: "envelope")
                    .font(.body)
                    Text("제출     ")
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
