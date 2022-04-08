//
//  CreateView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI

struct CreateView: View {
    
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @State var showingAlert = false
    
    @StateObject var createViewModel = CreateViewModel()
    
    var body: some View {
        
        NavigationView{
            VStack{
                ScrollView{
                    VStack{
                        nameTextField
                        descriptionTextEditor
                        input_descriptionTextEditor
                        output_descriptionTextEditor
                        input_file1TextEditor
                        output_file1TextEditor
                    }
                    VStack{
                        input_file2TextEditor
                        output_file2TextEditor
                        memoryTextField
                        timeTextField
                        scoreTextField
                    }
                    
                }.padding()
                    
                
            }// VStack
           
          
            .navigationBarTitle("문제 생성",displayMode:.inline)
            .toolbar(content: {
                createBtn
                    
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("계정 정보")
                        
                    }) {
                        Image(systemName: "person.crop.circle")
                        .font(.body)
                    }
                }
               
            })
                
                
            
        }
    }
       
}
       
    
// 문제 생성 버튼
extension CreateView {
  
    var createBtn : some View {
        Button(action: {
            print("createBtn")
            // 메모리와 타임이 숫자인지
            guard Int(self.$createViewModel.problem.limit.memory.wrappedValue) != nil
            else {
                self.showingAlert = true
                return
            }
      
            guard Int(self.$createViewModel.problem.limit.time.wrappedValue) != nil
            else {
                self.showingAlert = true
                return
            }
    
               
            // api 콜
            createViewModel.createProblem(token: token)
            
        }, label: {
            HStack {
                    Image(systemName: "plus.circle")
                    .font(.body)
                    Text("생성     ")
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
// problem write section
extension CreateView {
    
    // Name
    var nameTextField : some View{
        GroupBox("문제 이름"){
            TextField("문제 이름을 입력하세요.", text:self.$createViewModel.problem.name )
                .textFieldStyle(.roundedBorder)
        }
    }
    
    // Description
    var descriptionTextEditor : some View{
        GroupBox("문제"){
            TextEditor(text:self.$createViewModel.problem.description.description)
        }
    }
   
    // input_description
    var input_descriptionTextEditor : some View{
        GroupBox("입력"){
            TextEditor(text:self.$createViewModel.problem.description.input_description)
        }
    }
   
    // output_description
    var output_descriptionTextEditor : some View{
        GroupBox("출력"){
            TextEditor(text:self.$createViewModel.problem.description.output_description)
        }
    }
    // input_file 1
    var input_file1TextEditor : some View{
        GroupBox("예제 입력 1"){
            TextEditor(text:self.$createViewModel.input_file1)
        }
    }
    // output_file 1
    var output_file1TextEditor : some View{
        GroupBox("예제 출력 1"){
            TextEditor(text:self.$createViewModel.output_file1)
        }
    }

    // input_file 2
    var input_file2TextEditor : some View{
        GroupBox("예제 입력 2"){
            TextEditor(text:self.$createViewModel.input_file2)
        }
    }

    // output_file 2
    var output_file2TextEditor : some View{
        GroupBox("예제 출력 2"){
            TextEditor(text:self.$createViewModel.output_file2)
        }
    }

    // memory
    var memoryTextField : some View{
        GroupBox("메모리 제한"){
            TextField("256", text:self.$createViewModel.problem.limit.memory)
                .textFieldStyle(.roundedBorder)
        }
    }


    // time
    var timeTextField : some View{
        GroupBox("시간 제한"){
            TextField("2", text:self.$createViewModel.problem.limit.time)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    // score
    var scoreTextField : some View{
        GroupBox("점수"){
            TextField("1000", text:self.$createViewModel.problem.score)
                .textFieldStyle(.roundedBorder)
        }
    }

}


struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
