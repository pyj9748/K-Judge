//
//  CreateView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI

struct CreateView: View {
    @State private var descriptionHeight: CGFloat = 40
    @State private var input_descriptiontHeight: CGFloat = 40
    @State private var output_descriptiontHeightHeight: CGFloat = 40
    @State private var input_file1Height: CGFloat = 40
    @State private var output_file1Height: CGFloat = 40
    @State private var input_file2Height: CGFloat = 40
    @State private var output_file2Height: CGFloat = 40
  
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @State var showingAlert = false
    
    @StateObject var createViewModel = CreateViewModel()
    
    var body: some View {
        
        NavigationView{
            VStack{
                ScrollView{
                    VStack{
                       
                            nameTextField.onAppear (perform : UIApplication.shared.hideKeyboard)
                            descriptionTextEditor
                            input_descriptionTextEditor
                            output_descriptionTextEditor
                      
                        
                        
                    }.padding()
                    VStack{
                        
                            input_file1TextEditor
                            output_file1TextEditor
                            input_file2TextEditor
                            output_file2TextEditor
                    }.padding()
                    VStack{
                      
                            memoryTextField
                            timeTextField
                            scoreTextField
                      
                      
                    }.padding()
                    
                }
                    .navigationBarTitle("문제 생성",displayMode:.inline)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                print("계정 정보")
                                
                            }) {
                                Image(systemName: "person.crop.circle")
                                .font(.body)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            createBtn
                        }
                       
                    })
                Spacer()
            }// VStack
           
//            .navigationBarHidden(true)
//          .navigationBarTitle("문제 생성",displayMode:.inline)
//            .toolbar(content: {
//                createBtn
//
//            })
//            .toolbar(content: {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        print("계정 정보")
//
//                    }) {
//                        Image(systemName: "person.crop.circle")
//                        .font(.body)
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing){
//                    createBtn
//                }
//
//            })
                
                
            
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
      
        VStack(alignment:.leading){
            Text("문제 이름").font(.headline)
                TextField("문제 이름을 입력하세요.", text:self.$createViewModel.problem.name )
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
        
     
    }
    
    // Description
    var descriptionTextEditor : some View{
        VStack(alignment:.leading){
            Text("문제").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.problem.description.description, isFocused: .constant(true), inputHeight: $descriptionHeight)
                    .frame(height: descriptionHeight)
                    .border(Color("DefaultTextColor"), width: 2)
            
        }
    }
   
    // input_description
    var input_descriptionTextEditor : some View{
        VStack(alignment:.leading){
            Text("입력").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.problem.description.input_description, isFocused: .constant(true), inputHeight: $input_descriptiontHeight)
                    .frame(height: input_descriptiontHeight)
                    .border(Color("DefaultTextColor"), width: 2)
//            TextEditor(text:self.$createViewModel.problem.description.input_description).border(Color("DefaultTextColor"), width: 1)
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 400)
//                .cornerRadius(6.0)
        }
    }
   
    // output_description
    var output_descriptionTextEditor : some View{
        VStack(alignment:.leading){
            Text("출력").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.problem.description.output_description, isFocused: .constant(true), inputHeight: $output_descriptiontHeightHeight)
                    .frame(height: output_descriptiontHeightHeight)
                    .border(Color("DefaultTextColor"), width: 2)

        }
    }
    // input_file 1
    var input_file1TextEditor : some View{
        VStack(alignment:.leading){
            Text("예제 입력 1").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file1, isFocused: .constant(true), inputHeight: $input_file1Height)
                    .frame(height: input_file1Height)
                    .border(Color("DefaultTextColor"), width: 2)
           
        }
    }
    // output_file 1
    var output_file1TextEditor : some View{
        VStack(alignment:.leading){
            Text("예제 출력 1").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file1, isFocused: .constant(true), inputHeight: $output_file1Height)
                    .frame(height: output_file1Height)
                    .border(Color("DefaultTextColor"), width: 2)
        }
    }

    // input_file 2
    var input_file2TextEditor : some View{
        VStack(alignment:.leading){
            Text("예제 입력 2").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file2, isFocused: .constant(true), inputHeight: $input_file2Height)
                    .frame(height: input_file2Height)
                    .border(Color("DefaultTextColor"), width: 2)
        }
    }

    // output_file 2
    var output_file2TextEditor : some View{
        VStack(alignment:.leading){
            Text("예제 출력 2").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file2, isFocused: .constant(true), inputHeight: $output_file2Height)
                    .frame(height: output_file2Height)
                    .border(Color("DefaultTextColor"), width: 2)
        }
    }

    // memory
    var memoryTextField : some View{
        VStack(alignment:.leading){
            Text("메모리 제한").font(.headline)
            TextField("256", text:self.$createViewModel.problem.limit.memory)
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
    }


    // time
    var timeTextField : some View{
        VStack(alignment:.leading){
            Text("시간 제한").font(.headline)
            TextField("2", text:self.$createViewModel.problem.limit.time)
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
    }
    
    // score
    var scoreTextField : some View{
        VStack(alignment:.leading){
            Text("점수").font(.headline)
            TextField("1000", text:self.$createViewModel.problem.score)
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
    }

}


struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}


extension UIApplication {
    func hideKeyboard() {
        guard let window = windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
 }
 
extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
