//
//  ProblemEditView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/20.
//

import SwiftUI
import Alamofire

struct ProblemEditView: View {
    @Binding var problemId : String
    @StateObject var problemEditViewModel = ProblemEditViewModel()
    @State var showingAlert = false
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    nameTextField
                    descriptionTextEditor
                    input_descriptionTextEditor
                    output_descriptionTextEditor
                   
                }
                VStack{
                   
                    memoryTextField
                    timeTextField
                    scoreTextField
                }
                
            }.padding()
                
            
        }// VStack
       
      
        .navigationBarTitle("Edit Problem",displayMode:.inline)
        .toolbar(content: {
            editBtn
        })
    }
}

// problem write section
extension ProblemEditView {
    
    // Name
    var nameTextField : some View{
        GroupBox("Name"){
            TextField("Enter Name", text:self.$problemEditViewModel.problem.name )
                .textFieldStyle(.roundedBorder)
        }
    }
    
    // Description
    var descriptionTextEditor : some View{
        GroupBox("Description"){
            TextEditor(text:self.$problemEditViewModel.problem.description.description)
        }
    }
   
    // input_description
    var input_descriptionTextEditor : some View{
        GroupBox("InPut Description"){
            TextEditor(text:self.$problemEditViewModel.problem.description.input_description)
        }
    }
   
    // output_description
    var output_descriptionTextEditor : some View{
        GroupBox("OutPut Description"){
            TextEditor(text:self.$problemEditViewModel.problem.description.output_description)
        }
    }
   

    // memory
    var memoryTextField : some View{
        GroupBox("Memory"){
            TextField("256", text:self.$problemEditViewModel.problem.limit.memory)
                .textFieldStyle(.roundedBorder)
        }
    }


    // time
    var timeTextField : some View{
        GroupBox("Time"){
            TextField("2", text:self.$problemEditViewModel.problem.limit.time)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    // score
    var scoreTextField : some View{
        GroupBox("Score"){
            TextField("1000", text:self.$problemEditViewModel.problem.score)
                .textFieldStyle(.roundedBorder)
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
            
          
            let editProblem = EditProblem(name: problemEditViewModel.problem.name, score:Int( problemEditViewModel.problem.score)!, limit: PostLimit(time: Int(problemEditViewModel.problem.limit.time)!, memory: Int(problemEditViewModel.problem.limit.memory)!), description: PostDescription(description: problemEditViewModel.problem.description.description, input_description: problemEditViewModel.problem.description.input_description, output_description: problemEditViewModel.problem.description.output_description))

            AF.request("\(baseURL):8080/api/problems/\(problemId)",
                       method: .put,
                       parameters: editProblem,
                       encoder: JSONParameterEncoder.default).response { response in
                debugPrint(response)
            }
            
        }, label: {
            HStack {
                    Image(systemName: "pencil.circle")
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
