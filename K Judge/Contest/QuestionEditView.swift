//
//  ProblemEditView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/27.
//

import SwiftUI
import Alamofire
struct QuestionEditView: View {
    @State var showingAlert = false
    @State var questions : String = ""
    @Binding var challengeId : Int
    var body: some View {
        VStack{
            questionsTextField
            
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
    
   
    
    //Qusetions
    var questionsTextField : some View {
        GroupBox("Questions"){
            TextField("Enter Questions EX) 1,2,3,4", text:$questions )
                .textFieldStyle(.roundedBorder)
        }
    }
}

// 문제 수정 버튼
extension QuestionEditView {
  
    
    
    var editBtn : some View {
        Button(action: {
          
            // 문제의 값이 잘 들어갔는지
            guard self.questions.split(separator: ",").map({
                Int($0)!
            }) != []
            else {
                self.showingAlert = true
                return
            }
            
            
            
            
           
            let questions = self.questions.split(separator: ",").map({
                Int($0)!
            })
            
           
            
            let editQuestion = PutQuestion(questions: questions)

            AF.request("\(baseURL):8082/api/challenges/\(challengeId)/questions",
                       method: .put,
                       parameters: editQuestion,
                       encoder: JSONParameterEncoder.default).response { response in
                debugPrint(response)
            }
            
            
        }, label: {
            HStack {
                    Image(systemName: "square.grid.3x1.folder.badge.plus")
                    .font(.body)
                    Text("Edit")
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
            }
                
       
        
    }
}
