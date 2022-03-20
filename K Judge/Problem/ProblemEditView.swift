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

// 문제 생성 버튼
extension ProblemEditView {
  
    var editBtn : some View {
        Button(action: {
            print("createBtn")
            // 메모리와 타임이 숫자인지
//            guard Int(self.$createViewModel.problem.limit.memory.wrappedValue) != nil
//            else {
//                self.showingAlert = true
//                return
//            }
//
//            guard Int(self.$createViewModel.problem.limit.time.wrappedValue) != nil
//            else {
//                self.showingAlert = true
//                return
//            }
    
               
            // api 콜
            let parameters: [String: Any] = problemEditViewModel.problem.toJSON()
           problemEditViewModel.editProblem(parameters: parameters, problemId: problemId)
            
        }, label: {
            HStack {
                    Image(systemName: "plus.circle")
                    .font(.body)
                    Text("Create")
                        .fontWeight(.semibold)
                        .font(.body
                        )
                }
                .padding(6)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        })
//            .alert("타임과 메모리값 오류", isPresented: $showingAlert) {
//                Button("확인"){}
//            } message: {
//                Text("타임과 메모리는 정수값을 가져야 합니다.")
//            }
                
       
        
    }
}


struct ProblemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemEditView(problemId: .constant("1"))
    }
}
