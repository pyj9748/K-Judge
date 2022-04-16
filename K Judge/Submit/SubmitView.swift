//
//  SubmitView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI

// View
struct SubmitView: View {
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @Binding var challenge_id : Int
    let languages = [Language.JAVA.string , Language.CPP.string , Language.C.string]
    @State var selected_option : Int = 0
    
    @StateObject var submitViewModel = SubmitViewModel()
    @Binding var problemDetail : ProblemDetail
    var body: some View {
        NavigationView{
            VStack{
                
                pickerView

                Text("언어 : \(languages[self.selected_option])")
               
                CodeEditorView(source_code: self.$submitViewModel.submit.source_code, selected_option: self.$selected_option)
                   
              
                ProblemDescriptionView(problemDetail: $problemDetail)
                
                
                Spacer()
            }.navigationBarTitle("코드 제출",displayMode:.inline)
                .toolbar(content: {
                    submitBtn
                })
        }
        
    }
}

// 프로그래밍 언어 선택 picker view
extension SubmitView {
    var pickerView : some View {
        Picker(selection: $selected_option, label: Text("")) {
            ForEach(0..<languages.count, id: \.self) { index in
                Text(languages[index])
                
            }
            
        }.onChange(of: selected_option, perform: { _ in
            self.$submitViewModel.submit.source_code.wrappedValue = init_codes[selected_option]
            self.submitViewModel.submit.programming_language = languages[selected_option]
        })
    }
}

// submit button
extension SubmitView {
    var submitBtn : some View {
       
        Button(action: {
            print("submitBtn")
            print("problemid : ",self.problemDetail.id)
            print("challengeid : ",self.challenge_id)
            print("source code : ",self.submitViewModel.submit.source_code)
            print("language : ",self.submitViewModel.submit.programming_language)
            // submit api 콜
            submitViewModel.gradeSubmitCode(problemId: problemDetail.id, challengeId: challenge_id, token: token)
            
        }, label: {
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

struct SubmitView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitView(challenge_id: .constant(10), problemDetail: .constant(ProblemDetail(id: 1, name: "name", description: "des", input_description: "in_des", output_description: "out_des", score: 100)))
    }
}

