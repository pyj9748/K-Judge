//
//  CreateView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI

struct CreateView: View {
    var difficulty : [String] = ["상","중","하"]
    //@FocusState var isInputActive: Bool
    @State private var testCaseNum: Int = 2
    @State private var selectedDifficulty: Int = 1
    
    @State private var descriptionHeight: CGFloat = 40
    @State private var input_descriptiontHeight: CGFloat = 40
    @State private var output_descriptiontHeightHeight: CGFloat = 40
    @State private var input_file1Height: CGFloat = 40
    @State private var output_file1Height: CGFloat = 40
    @State private var input_file2Height: CGFloat = 40
    @State private var output_file2Height: CGFloat = 40
    @State private var input_file3Height: CGFloat = 40
    @State private var output_file3Height: CGFloat = 40
    @State private var input_file4Height: CGFloat = 40
    @State private var output_file4Height: CGFloat = 40
    @State private var input_file5Height: CGFloat = 40
    @State private var output_file5Height: CGFloat = 40
    @State private var input_file6Height: CGFloat = 40
    @State private var output_file6Height: CGFloat = 40
    @State private var input_file7Height: CGFloat = 40
    @State private var output_file7Height: CGFloat = 40
    @State private var input_file8Height: CGFloat = 40
    @State private var output_file8Height: CGFloat = 40
  
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @State var showingAlert = false
    @State var showingTitleAlert = false
    @State var showSuccess = false
    
    
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
                        Group{
                            input_file1TextEditor
                            output_file1TextEditor
                            input_file2TextEditor
                            output_file2TextEditor
                            
                            
                            
                           
                            
                            
                        }
                        Group{
                            if testCaseNum >= 3 {
                                input_file3TextEditor
                                output_file3TextEditor
                            }
                            if testCaseNum >= 4 {
                                input_file4TextEditor
                                output_file4TextEditor
                            }
                            if testCaseNum >= 5 {
                                input_file5TextEditor
                                output_file5TextEditor
                            }
                            if testCaseNum >= 6 {
                                input_file6TextEditor
                                output_file6TextEditor
                            }
                            if testCaseNum >= 7 {
                                input_file7TextEditor
                                output_file7TextEditor
                            }
                            if testCaseNum >= 8 {
                                input_file8TextEditor
                                output_file8TextEditor
                            }
                            appendButton
                        }
                    }.padding()
                    VStack{
                      
                          
                            timeTextField
                            scoreField
                      
                    }.padding()
                    
                }
                    .navigationBarTitle("문제 생성",displayMode:.inline)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink(destination: UserInfoView(), label: {
                               
                                    Image(systemName: "person.crop.circle")
                                    .font(.body)
                                
                                
                            })
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
             // 메모리  숫자인지
      
            guard Int(self.$createViewModel.problem.limit.time.wrappedValue) != nil
            else {
                self.showingAlert = true
                return
            }
            
            guard self.$createViewModel.problem.name.wrappedValue != ""
            else {
                self.showingTitleAlert = true
                return
            }
    
               
            // api 콜
            createViewModel.createProblem(token: token,testCaseNum: self.testCaseNum)
            showSuccess = true
            
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
                Text("시간제한은 정수값을 가져야 합니다.")
            }
            .alert("타임과 메모리값 오류", isPresented: $showingTitleAlert) {
                Button("확인"){}
            } message: {
                Text("문제이름은 공백일 수 없습니다.")
            }.alert("성공", isPresented: $showSuccess) {
                Button("확인"){}
            } message: {
                Text("문제생성 완료")
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
                //.submitLabel(.next)
                .onAppear(){
                    self.$createViewModel.problem.name.wrappedValue = ""
                }
                
                
        }
        
     
    }
    
    // Description
    var descriptionTextEditor : some View{
        VStack(alignment:.leading){
                Text("문제").font(.headline)
                UITextViewRepresentable(text: self.$createViewModel.problem.description.description, isFocused: .constant(true), inputHeight: $descriptionHeight)

                        .frame(height: descriptionHeight)
                        .border(Color("DefaultTextColor"), width: 2)
        }.onAppear(){
            self.$createViewModel.problem.description.description.wrappedValue = "Enter description"
        }
    }
   
    // input_description
    var input_descriptionTextEditor : some View{
        VStack(alignment:.leading){
            Text("입력").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.problem.description.input_description, isFocused: .constant(true), inputHeight: $input_descriptiontHeight)
                    .frame(height: input_descriptiontHeight)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.problem.description.input_description.wrappedValue = "Enter input description"
                    }

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
                    .onAppear(){
                        self.$createViewModel.problem.description.output_description.wrappedValue = "Enter output description"
                    }

        }
    }
    // input_file 1
    var input_file1TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 입력 1").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file1, isFocused: .constant(true), inputHeight: $input_file1Height)
                    .frame(height: input_file1Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.input_file1.wrappedValue = """
    Enter Input File Content
    """
                        
                    }
           
        }
    }
    // output_file 1
    var output_file1TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 출력 1").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file1, isFocused: .constant(true), inputHeight: $output_file1Height)
                    .frame(height: output_file1Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.output_file1.wrappedValue = """
    Enter Output File Content
    """
                        
                    }
        }
    }

    // input_file 2
    var input_file2TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 입력 2").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file2, isFocused: .constant(true), inputHeight: $input_file2Height)
                    .frame(height: input_file2Height)
                    .border(Color("DefaultTextColor"), width: 2).onAppear(){
                        self.$createViewModel.input_file2.wrappedValue = """
    Enter Input File Content
    """
                        
                    }
        }
    }

    // output_file 2
    var output_file2TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 출력 2").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file2, isFocused: .constant(true), inputHeight: $output_file2Height)
                    .frame(height: output_file2Height)
                    .border(Color("DefaultTextColor"), width: 2).onAppear(){
                        self.$createViewModel.output_file2.wrappedValue = """
    Enter Output File Content
    """
                        
                    }
        }
    }
    // input_file 3
    var input_file3TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 입력 3").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file3, isFocused: .constant(true), inputHeight: $input_file3Height)
                    .frame(height: input_file3Height)
                    .border(Color("DefaultTextColor"), width: 2).onAppear(){
                        self.$createViewModel.input_file3.wrappedValue = """
    Enter Input File Content
    """
                        
                    }
        }
    }

    // output_file 3
    var output_file3TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 출력 3").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file3, isFocused: .constant(true), inputHeight: $output_file3Height)
                    .frame(height: output_file3Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.output_file3.wrappedValue = """
    Enter Output File Content
    """
                        
                    }
        }
    }
    // input_file 4
    var input_file4TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 입력 4").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file4, isFocused: .constant(true), inputHeight: $input_file4Height)
                    .frame(height: input_file4Height)
                    .border(Color("DefaultTextColor"), width: 2).onAppear(){
                        self.$createViewModel.input_file4.wrappedValue = """
    Enter Input File Content
    """
                        
                    }
        }
    }

    // output_file 4
    var output_file4TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 출력 4").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file4, isFocused: .constant(true), inputHeight: $output_file4Height)
                    .frame(height: output_file4Height)
                    .border(Color("DefaultTextColor"), width: 2).onAppear(){
                        self.$createViewModel.output_file4.wrappedValue = """
    Enter Output File Content
    """
                        
                    }
        }
    }
    // input_file 5
    var input_file5TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 입력 5").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file5, isFocused: .constant(true), inputHeight: $input_file5Height)
                    .frame(height: input_file5Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.input_file5.wrappedValue = """
    Enter Input File Content
    """
                        
                    }
        }
    }

    // output_file 5
    var output_file5TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 출력 5").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file5, isFocused: .constant(true), inputHeight: $output_file5Height)
                    .frame(height: output_file5Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.output_file5.wrappedValue = """
    Enter Output File Content
    """
                        
                    }
        }
    }
    // input_file 6
    var input_file6TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 입력 6").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file6, isFocused: .constant(true), inputHeight: $input_file6Height)
                    .frame(height: input_file6Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.input_file6.wrappedValue = """
    Enter Input File Content
    """
                        
                    }
        }
    }

    // output_file 6
    var output_file6TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 출력 6").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file6, isFocused: .constant(true), inputHeight: $output_file6Height)
                    .frame(height: output_file6Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.output_file6.wrappedValue = """
    Enter Output File Content
    """
                        
                    }
        }
    }
    // input_file 7
    var input_file7TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 입력 7").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file7, isFocused: .constant(true), inputHeight: $input_file7Height)
                    .frame(height: input_file7Height)
                    .border(Color("DefaultTextColor"), width: 2).onAppear(){
                        self.$createViewModel.input_file7.wrappedValue = """
    Enter Input File Content
    """
                        
                    }
        }
    }

    // output_file 7
    var output_file7TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 출력 7").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file7, isFocused: .constant(true), inputHeight: $output_file7Height)
                    .frame(height: output_file7Height)
                    .border(Color("DefaultTextColor"), width: 2).onAppear(){
                        self.$createViewModel.output_file7.wrappedValue = """
    Enter Output File Content
    """
                        
                    }
        }
    }
    // input_file 8
    var input_file8TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 입력 8").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.input_file8, isFocused: .constant(true), inputHeight: $input_file8Height)
                    .frame(height: input_file8Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.input_file8.wrappedValue = """
    Enter Input File Content
    """
                        
                    }
        }
    }

    // output_file 8
    var output_file8TextEditor : some View{
        VStack(alignment:.leading){
            Text("테케 출력 8").font(.headline)
            UITextViewRepresentable(text: self.$createViewModel.output_file8, isFocused: .constant(true), inputHeight: $output_file8Height)
                    .frame(height: output_file8Height)
                    .border(Color("DefaultTextColor"), width: 2)
                    .onAppear(){
                        self.$createViewModel.output_file8.wrappedValue = """
    Enter Output File Content
    """
                        
                    }
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
            TextField("5", text:self.$createViewModel.problem.limit.time)
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
    }
    
    // score
    var scoreField : some View{
        HStack(alignment: .center, spacing: 10){
           
            
            Button(action: {
                createViewModel.problem.score = "150"
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
                createViewModel.problem.score = "100"
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
                createViewModel.problem.score = "50"
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

    // difficulty : 상:150 중:100 하:50
    var scoreDifficultyField : some View{
            
        VStack(alignment:.leading) {
                Text("난이도").font(.headline)
                    Picker("문제의 난이도를 골라주세요", selection: $selectedDifficulty) {
                        ForEach(0..<difficulty.count) {
                            Text(self.difficulty[$0])       .border(Color("DefaultTextColor"), width: 2)
                            
                        }
                    }.onChange(of: selectedDifficulty) { select in
                        switch select{
                        case 0:
                            createViewModel.problem.score = "150"
                        case 1:
                            createViewModel.problem.score = "100"
                        case 2:
                            createViewModel.problem.score = "50"
                        default:
                            return
                        }
                    }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var appendButton : some View{
        HStack{
            Button(action: {
                if testCaseNum < 8 {
                    self.testCaseNum += 1
                }
                
            }, label: {
                
                Text(" 테스트케이스 + ")
                    .padding(20)
                    .background(Color("KWColor1"))
                    .foregroundColor(Color.white)
                    .buttonBorderShape(.roundedRectangle)
                    .cornerRadius(20)
            })
            Button(action: {
                
                if testCaseNum > 2 {
                    self.testCaseNum -= 1
                }
            }, label: {
                
                Text(" 테스트케이스 - ")
                    .padding(20)
                    .background(Color("KWColor1"))
                    .foregroundColor(Color.white)
                    .buttonBorderShape(.roundedRectangle)
                    .cornerRadius(20)
            })
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
