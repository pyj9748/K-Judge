//
//  ProblemEditView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/27.
//

import SwiftUI
import Alamofire
import SwiftyJSON
struct QuestionEditView: View {
    @State var showAlert = false
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @State var showingAlert = false
    @State var questions : String = ""
    @Binding var challengeId : Int
    @State var multiSelection = Set<String>()
    @StateObject var problemListViewModel = ProblemListViewModel()
    
    var body: some View {
        VStack{
            Text("").onAppear(){
                problemListViewModel.problemList = problemListViewModel.getProblemList(token: token)
            }
            questionsListSelect
            
        } .navigationBarTitle("Edit Question",displayMode:.inline)
            .toolbar(content: {
                editBtn
            })
        
    }
}

struct QuestionEditView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionEditView(challengeId: .constant(1))
    }
}

struct PutQuestion : Encodable{
    let questions : [Int]
}

// questions Edit section
extension  QuestionEditView {
    
    var questionsListSelect: some View {
        GroupBox("출제 문제"){
            NavigationLink(destination: ProblemSelectionView(problemList: $problemListViewModel.problemList , multiSelection: $multiSelection),label: {
               Text("출제 문제 선택하기")
            })
            Text("출제 문제 개수 : \(multiSelection.count)")
            Text("출제 문제 개수 : \(multiSelection.description)")
        }
       
    }
    
    //Qusetions
    var questionsTextField : some View {
        GroupBox("출제 문제 선택"){
            TextField("출제할 문제들을 입력하세요. EX) 1,2,3,4", text:$questions )
                .textFieldStyle(.roundedBorder)
        }
    }
}

// 문제 수정 버튼
extension QuestionEditView {
  
    
    
    var editBtn : some View {
        Button(action: {
          
            // 문제의 값이 잘 들어갔는지
//            guard self.questions.split(separator: ",").map({
//                Int($0)!
//            }) != []
//            else {
//                self.showingAlert = true
//                return
//            }
            
            
            
            
            let questions =
            self.$multiSelection.wrappedValue.map({
                Int($0)!
            })
//            let questions = self.questions.split(separator: ",").map({
//                Int($0)!
//            })
            
            // Header
            let headers : HTTPHeaders = [
                        "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
           
            
            let editQuestion = PutQuestion(questions: questions)

            AF.request("\(baseURL):8080/api/challenges/\(challengeId)/questions",
                       method: .put,
                       parameters: editQuestion,
                       encoder: JSONParameterEncoder.default,headers: headers).response { response in
                debugPrint(response)
            }.responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    if json["error"]["status"] != NULL {
//
//                        showAlert = true
//                        return
//                    }
                   
                default:
                    showAlert = true
                    return
                }

            })
            
            
        }, label: {
            HStack {
                    Image(systemName: "square.grid.3x1.folder.badge.plus")
                    .font(.body)
                    Text("수정     ")
                        .fontWeight(.semibold)
                        .font(.body
                        )
                }
                .padding(6)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        })
            .alert("문제값 오류", isPresented: $showingAlert) {
                Button("확인"){}
            } message: {
                Text("문제의 양식을 잘 지켜주세요😘")
            }.alert("대회의 주최자가 아닙니다.", isPresented: $showAlert) {
                Button("확인"){}
            } message: {
                Text("대회의 주최자만 대회 정보를 수정 가능합니다.😘")
            }
                
       
        
    }
}
