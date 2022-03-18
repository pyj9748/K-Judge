//
//  ContestCreateView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

struct ContestCreateView: View {
    
    @State var showingAlert = false
    @State var questions : String = ""
    @State var start_time = Date()
    @State var end_time = Date()
    @State var numOfAuthors : Int = 1
    
    let numOfAuthorArray = [1,2,3,4]
    @State var selectedNumOfAuthor = 0
   // @State var authorArray : [Author] = []
    
    @State var author1_user_id : String = "author1 user_id"
    @State var author1_name : String = "author1 name"
    @State var author1_accumulate_score : String = "author1 accumulate_score"
    @State var author2_user_id : String = "author2 user_id"
    @State var author2_name : String = "author2 name"
    @State var author2_accumulate_score : String = "author2 accumulate_score"
    @State var author3_user_id : String = "author3 user_id"
    @State var author3_name : String = "author3 name"
    @State var author3_accumulate_score : String = "author3 accumulate_score"
    @State var author4_user_id : String = "author4 user_id"
    @State var author4_name : String = "author4 name"
    @State var author4_accumulate_score : String = "author4 accumulate_score"
     
    
    @StateObject var contestCreateViewModel = ContestCreateViewModel()
    
        
    
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    nameTextField
                    questionsTextField
                    numOfAuthorsPicker
                    if numOfAuthors >= 1 {
                        author1
                    }
                    if numOfAuthors >= 2 {
                        author2
                    }
                    if numOfAuthors >= 3 {
                        author3
                    }
                    if numOfAuthors >= 4 {
                        author4
                    }
                    start_datePicker
                    end_datePicker
                }.padding()
            }  .navigationBarTitle("Create Contest",displayMode:.inline)
                .toolbar(content: {
                    createBtn
                })
        }
    }
}

// 대회 생성 버튼
extension ContestCreateView {
  
    
    
    var createBtn : some View {
        Button(action: {
            print("createBtn")
            // 문제의 값이 잘 들어갔는지
            
            
            guard self.questions.split(separator: ",").map({
                Int($0)!
            }) != []
            else {
                self.showingAlert = true
                return
            }

            print(self.questions.split(separator: ",").map({
                Int($0)!
            }))
            // api 콜
            
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
                .background(Color.indigo)
                .cornerRadius(40)
        })
            .alert("문제값 오류", isPresented: $showingAlert) {
                Button("확인"){}
            } message: {
                Text("문제의 양식을 잘 지켜주세요😘")
            }
                
       
        
    }
}
// problem write section
extension ContestCreateView {
    
    // Name
    var nameTextField : some View{
        GroupBox("Name"){
            TextField("Enter Name", text:self.$contestCreateViewModel.contest.name)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    //Qusetions
    var questionsTextField : some View {
        GroupBox("Questions"){
            TextField("Enter Questions EX) 1,2,3,4", text:$questions )
                .textFieldStyle(.roundedBorder)
        }
    }
    
    // Authors
    var numOfAuthorsPicker : some View {
        GroupBox("Authors"){
            VStack {
                Picker("작성자 수를 고르세요", selection: $selectedNumOfAuthor) {
                    ForEach(0 ..< numOfAuthorArray.count, id:\.self) { i in
                        Text(String(numOfAuthorArray[i]))
                    }
                }.onChange(of: selectedNumOfAuthor, perform: { _ in
                    self.numOfAuthors = numOfAuthorArray[selectedNumOfAuthor]
                })
                
                Text("\(numOfAuthorArray[selectedNumOfAuthor])명의 작성자가 있습니다.")
            }.pickerStyle(SegmentedPickerStyle())
        }
    }

    // author1
    var author1 : some View {
        GroupBox("Author1"){
            VStack{
                TextField("author1 user id ",text: $author1_user_id)
                    .textFieldStyle(.roundedBorder)
                TextField("author1 name",text: $author1_name)
                    .textFieldStyle(.roundedBorder)
                TextField("author1 score",text: $author1_accumulate_score)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    // author2
    var author2 : some View {
        GroupBox("Author2"){
            VStack{
                TextField("author2 user id ",text: $author2_user_id) .textFieldStyle(.roundedBorder)
                TextField("author2 name",text: $author2_name) .textFieldStyle(.roundedBorder)
                TextField("author2 score",text: $author2_accumulate_score) .textFieldStyle(.roundedBorder)
            }
        }
    }
    // author3
    var author3 : some View {
        GroupBox("Author3"){
            VStack{
                TextField("author3 user id ",text: $author3_user_id) .textFieldStyle(.roundedBorder)
                TextField("author3 name",text: $author3_name) .textFieldStyle(.roundedBorder)
                TextField("author3 score",text: $author3_accumulate_score) .textFieldStyle(.roundedBorder)
            }
        }
    }
    // author4
    var author4 : some View {
        GroupBox("Author4"){
            VStack{
                TextField("author4 user id ",text: $author4_user_id) .textFieldStyle(.roundedBorder)
                TextField("author4 name",text: $author4_name) .textFieldStyle(.roundedBorder)
                TextField("author4 score",text: $author4_accumulate_score) .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    // Challenge_date_time
    var start_datePicker : some View {
        GroupBox("Start Date"){
            DatePicker("start_date", selection: $start_time, in: Date()...)
                       .datePickerStyle(WheelDatePickerStyle())
                       .labelsHidden()
        }
    }
    var end_datePicker : some View {
        GroupBox("End Date"){
            DatePicker("end_date", selection: $end_time, in: Date()...)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
        }
    }
  

}

struct ContestCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ContestCreateView()
    }
}
