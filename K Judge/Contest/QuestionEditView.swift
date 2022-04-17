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
    //  정부수정은 대회 시작 전에만
    @State var showNow = false
    // 출제 문제 배열 공백
    @State var showQuestionsAlert = false
    // 주최자가 아닌 경우
    @State var showAlert = false
    // 성공
    @State var showSuccess = false
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
      
            NavigationLink(destination: ProblemSelectionView(problemList: $problemListViewModel.problemList , multiSelection: $multiSelection),label: {
               //Text("출제 문제 선택하기")
              
                
                Text("출제 문제 선택하기")
                    .fontWeight(.semibold)
                    .font(.title)
                    .padding(30)
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(Color("KWColor1"))
                    .cornerRadius(10)
            })
           
       
       
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
          
      
            // 출제 문제 배열 공백
            guard self.$multiSelection.wrappedValue.count != 0
            else {
                showQuestionsAlert = true
                return
            }
            
            
            let questions =
            self.$multiSelection.wrappedValue.map({
                Int($0)!
            })

            
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
                     
                    if json["error"]["status"].intValue == 403 {
                        showAlert = true
                       
                        //return
                    }
                    if json["error"]["status"].intValue == 400 {
                        showNow = true
                       
                        return
                    }
                    if json["data"]["message"].stringValue == "You have successfully changed the questions."{
                        showSuccess = true
                        //return
                    }
                   
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
        .alert("출제문제 배열 공백오류", isPresented: $showQuestionsAlert) {
            Button("확인"){}
        } message: {
            Text("적어도 한 문제이상 출제해야 합니다.")
        }
            .alert("대회의 주최자가 아닙니다.", isPresented: $showAlert) {
                Button("확인"){}
            } message: {
                Text("대회의 주최자만 대회 정보를 수정 가능합니다.😘")
            }
            .alert("성공", isPresented: $showSuccess) {
                Button("확인"){}
            } message: {
                Text("대회문제 수정 완료")
            }
            .alert("대회수정 시각오류", isPresented: $showNow) {
                Button("확인"){}
            } message: {
                Text("대회수정은 대회시작 전에만 가능합니다.")
            }
                
       
        
    }
}
