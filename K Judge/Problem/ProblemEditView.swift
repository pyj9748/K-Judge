//
//  ProblemEditView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/20.
//

import SwiftUI
import Alamofire

struct ProblemEditView: View {
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @Binding var problemId : String
    @StateObject var problemEditViewModel = ProblemEditViewModel()
    @State private var descriptionHeight: CGFloat = 40
    @State private var input_descriptiontHeight: CGFloat = 40
    @State private var output_descriptiontHeightHeight: CGFloat = 40
    @State var showingAlert = false
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    nameTextField
                    descriptionTextEditor
                    input_descriptionTextEditor
                    output_descriptionTextEditor
                   
                }.padding()
                VStack{
                   
                    memoryTextField
                    timeTextField
                    scoreTextField
                }.padding()
                
            }
                
            
        }// VStack
       
      
        .navigationBarTitle("문제 수정",displayMode:.inline)
        .toolbar(content: {
            editBtn
        })
    }
}

// problem write section
extension ProblemEditView {
    
    // Name
    var nameTextField : some View{
        VStack(alignment:.leading){
            Text("문제 이름").font(.headline)
            TextField("문제 이름을 입력하세요", text:self.$problemEditViewModel.problem.name )
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
            
            
        }
    }
    
    // Description
    var descriptionTextEditor : some View{
        VStack(alignment:.leading){
            Text("문제").font(.headline)
            UITextViewRepresentable(text: self.$problemEditViewModel.problem.description.description, isFocused: .constant(true), inputHeight: $descriptionHeight)
                    .frame(height: descriptionHeight)
                    .border(Color("DefaultTextColor"), width: 2)
            
        }
//        GroupBox("문제"){
//            TextEditor(text:self.$problemEditViewModel.problem.description.description)
//        }
    }
   
    // input_description
    var input_descriptionTextEditor : some View{
        VStack(alignment:.leading){
            Text("입력").font(.headline)
            UITextViewRepresentable(text: self.$problemEditViewModel.problem.description.input_description, isFocused: .constant(true), inputHeight: $input_descriptiontHeight)
                    .frame(height: input_descriptiontHeight)
                    .border(Color("DefaultTextColor"), width: 2)
//        GroupBox("입력"){
//            TextEditor(text:self.$problemEditViewModel.problem.description.input_description)
            
        }
    }
   
    // output_description
    var output_descriptionTextEditor : some View{
        
        VStack(alignment:.leading){
            Text("출력").font(.headline)
            UITextViewRepresentable(text: self.$problemEditViewModel.problem.description.output_description, isFocused: .constant(true), inputHeight: $output_descriptiontHeightHeight)
                    .frame(height: output_descriptiontHeightHeight)
                    .border(Color("DefaultTextColor"), width: 2)

        }
//        GroupBox("출력"){
//            TextEditor(text:self.$problemEditViewModel.problem.description.output_description)
//        }
    }
   

    // memory
    var memoryTextField : some View{
        VStack(alignment:.leading){
            Text("메모리 제한").font(.headline)
            TextField("256", text:self.$problemEditViewModel.problem.limit.memory)
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
      
    }


    // time
    var timeTextField : some View{
        VStack(alignment:.leading){
            Text("시간 제한").font(.headline)
            TextField("2", text:self.$problemEditViewModel.problem.limit.time)
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
       
    }
    
    // score
    var scoreTextField : some View{
        VStack(alignment:.leading){
            Text("점수").font(.headline)
            TextField("1000", text:self.$problemEditViewModel.problem.score)
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
       
    }

}

// 문제 수정 버튼
extension ProblemEditView {
  
    var editBtn : some View {
        Button(action: {
            print("createBtn")
            // 메모리와 타임이 숫자인지
            guard Int(self.$problemEditViewModel.problem.limit.memory.wrappedValue) != nil
            else {
                self.showingAlert = true
                return
            }

            guard Int(self.$problemEditViewModel.problem.limit.time.wrappedValue) != nil
            else {
                self.showingAlert = true
                return
            }
    
               
            // api 콜
            
            // Header
            let headers : HTTPHeaders = [
                        "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
            
            let editProblem = EditProblem(name: problemEditViewModel.problem.name, score:Int( problemEditViewModel.problem.score)!, limit: PostLimit(time: Int(problemEditViewModel.problem.limit.time)!, memory: Int(problemEditViewModel.problem.limit.memory)!), description: PostDescription(description: problemEditViewModel.problem.description.description, input_description: problemEditViewModel.problem.description.input_description, output_description: problemEditViewModel.problem.description.output_description))

            AF.request("\(baseURL):8080/api/problems/\(problemId)",
                       method: .put,
                       parameters: editProblem,
                       encoder: JSONParameterEncoder.default,headers: headers).response { response in
                debugPrint(response)
            }
            
        }, label: {
            HStack {
                    Image(systemName: "pencil.circle")
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
        .alert("타임과 메모리값 오류", isPresented: $showingAlert) {
            Button("확인"){}
        } message: {
            Text("타임과 메모리는 정수값을 가져야 합니다.")
        }
                
       
        
    }
}


struct ProblemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemEditView(problemId: .constant("1"))
    }
}

struct EditProblem : Encodable  {
    let name :String
    let score : Int
    let limit : PostLimit
    let description : PostDescription
    
}
struct PostLimit : Encodable {
    let time : Int
    let memory : Int
}
struct PostDescription : Encodable {
    
    let description : String
    let input_description : String
    let output_description : String
}
