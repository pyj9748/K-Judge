//
//  ProblemEditView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/20.
//

import SwiftUI
import Alamofire

struct ProblemEditView: View {
    var difficulty : [String] = ["상","중","하"]
    @State private var selectedDifficulty: Int = 1
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @Binding var problemId : String
    @Binding var problemEditViewModel :ProblemItemViewModel
    @State private var descriptionHeight: CGFloat = 280
    @State private var input_descriptiontHeight: CGFloat = 280
    @State private var output_descriptiontHeightHeight: CGFloat = 280
    @State var showingAlert = false
    @State var showingTitleAlert = false
    @State var showSuccess = false
    
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
                   
                    
                    timeTextField
                   scoreField
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
    // difficulty : 상:150 중:100 하:50
    // score
    var scoreField : some View{
        HStack(alignment: .center, spacing: 10){
           
            
            Button(action: {
                problemEditViewModel.problem.score = "150"
                selectedDifficulty = 0
            }, label: {
                
                Text(" 상            ")
                    .padding(20)
                    .background( self.selectedDifficulty == 0 ? Color.blue : Color("KWColor1"))
                    .foregroundColor(Color.white)
                    .buttonBorderShape(.roundedRectangle)
                    .cornerRadius(20)
                
            })
            Button(action: {
                problemEditViewModel.problem.score = "100"
                selectedDifficulty = 1
            }, label: {
                
                Text(" 중            ")
                    .padding(20)
                    .background( self.selectedDifficulty == 1 ? Color.blue : Color("KWColor1"))
                    .foregroundColor(Color.white)
                    .buttonBorderShape(.roundedRectangle)
                    .cornerRadius(20)
                
            })
            Button(action: {
                problemEditViewModel.problem.score = "50"
                selectedDifficulty = 2
            }, label: {
                
                Text(" 하            ")
                    .padding(20)
                    .background( self.selectedDifficulty == 2 ? Color.blue : Color("KWColor1"))
                    .foregroundColor(Color.white)
                    .buttonBorderShape(.roundedRectangle)
                    .cornerRadius(20)
                
            })
         
        }//.background(Color.gray)
            .cornerRadius(20)
    }
    
  
    var editBtn : some View {
        Button(action: {
            print("createBtn")
            // 메모리 숫자인지

            guard Int(self.$problemEditViewModel.problem.limit.time.wrappedValue) != nil
            else {
                self.showingAlert = true
                return
            }
            // 문제명 공백
            guard self.$problemEditViewModel.problem.name.wrappedValue != ""
            else {
                self.showingTitleAlert = true
                return
            }
               
            // api 콜
            
            // Header
            let headers : HTTPHeaders = [
                        "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
            
            let editProblem = EditProblem(name: problemEditViewModel.problem.name, score:Int( problemEditViewModel.problem.score)!, limit: PostLimit(time: Int(problemEditViewModel.problem.limit.time)!, memory: 1500), description: PostDescription(description: problemEditViewModel.problem.description.description, input_description: problemEditViewModel.problem.description.input_description, output_description: problemEditViewModel.problem.description.output_description))

            AF.request("\(baseURL):8080/api/problems/\(problemId)",
                       method: .put,
                       parameters: editProblem,
                       encoder: JSONParameterEncoder.default,headers: headers).response { response in
                debugPrint(response)
                showSuccess = true
                presentationMode.wrappedValue.dismiss()
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
        .alert("시간제한 값 오류", isPresented: $showingAlert) {
            Button("확인"){}
        } message: {
            Text("시간제한은 정수값을 가져야 합니다.")
        }
        .alert("타임과 메모리값 오류", isPresented: $showingTitleAlert) {
            Button("확인"){}
        } message: {
            Text("문제이름은 공백일 수 없습니다.")
        }.alert("성공", isPresented: $showSuccess) {
            Button("확인"){}
        } message: {
            Text("문제수정 완료")
        }
                
       
        
    }
}


struct ProblemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemEditView( problemId: .constant("1"), problemEditViewModel: .constant(ProblemItemViewModel()))
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
