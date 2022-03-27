//
//  ContestCreateView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI
import SwiftyJSON
import Alamofire

struct ContestCreateView: View {
    
    @State var showingAlert = false
    @State var questions : String = ""
    @State var numOfAuthors : Int = 1
    
    let numOfAuthorArray = [1,2,3,4]
    @State var selectedNumOfAuthor = 0
    
    
    @State var author1_user_id : String = ""
    @State var author1_name : String = ""
    @State var author1_accumulate_score : String = ""
    @State var author2_user_id : String = ""
    @State var author2_name : String = ""
    @State var author2_accumulate_score : String = ""
    @State var author3_user_id : String = ""
    @State var author3_name : String = ""
    @State var author3_accumulate_score : String = ""
    @State var author4_user_id : String = ""
    @State var author4_name : String = ""
    @State var author4_accumulate_score : String = ""
     
    
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
            
            
            
            
            // api call = create Contest
          
            // authors
            var authorArray : [Author] = [
                Author( user_id: 0, name: author1_name, accumulate_score: 0),
                Author(  user_id:0, name: author2_name, accumulate_score: 0),
                Author( user_id: 0, name: author3_name, accumulate_score: 0),
                Author( user_id: 0, name: author4_name, accumulate_score: 0),
            ]
            for i in 0..<numOfAuthors {
                if i == 0{
                    authorArray[i].user_id = Int(author1_user_id)!
                    authorArray[i].accumulate_score = Int(author1_accumulate_score)!
                }
                else if i == 1 {
                    authorArray[i].user_id = Int(author2_user_id)!
                    authorArray[i].accumulate_score = Int(author2_accumulate_score)!
                }
                else if i == 2 {
                    authorArray[i].user_id = Int(author3_user_id)!
                    authorArray[i].accumulate_score = Int(author3_accumulate_score)!
                }
                else {
                    authorArray[i].user_id = Int(author4_user_id)!
                    authorArray[i].accumulate_score = Int(author4_accumulate_score)!
                }
              
            }
            contestCreateViewModel.contest.authors = []
            for i in 0..<numOfAuthors {
                contestCreateViewModel.contest.authors.append( authorArray[i])
            }
            // author의 user id , accumulate 값이 유효한지
//            for i in 0..<numOfAuthors {
//
//                guard let _ = contestCreateViewModel.contest.authors[i].user_id
//                else {
//                    self.showingAlert = true
//                    return
//                }
//                guard let _ = contestCreateViewModel.contest.authors[i].accumulate_score
//                else {
//                    self.showingAlert = true
//                    return
//                }
//            }
            contestCreateViewModel.contest.questions = self.questions.split(separator: ",").map({
                Int($0)!
            })
            
            let start = contestCreateViewModel.getStartDate()
            let end = contestCreateViewModel.getEndDate()
            
           
            
            //contestCreateViewModel.createContest(parameters: parameters)
            
            
            let postContest = PostContest(authors: contestCreateViewModel.contest.authors, name: contestCreateViewModel.contest.name, challenge_date_time: PostChallengeDate(start_time: start, end_time: end), questions: contestCreateViewModel.contest.questions)
           

            AF.request("\(baseURL):8082/api/challenges",
                       method: .post,
                       parameters: postContest,
                       encoder: JSONParameterEncoder.default).response { response in
                debugPrint(response)
            }
            
            
            
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
                TextField("user id ex) 1",text: $author1_user_id)
                    .textFieldStyle(.roundedBorder)
                TextField("name",text: $author1_name)
                    .textFieldStyle(.roundedBorder)
                TextField("score ex) 1000",text: $author1_accumulate_score)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    // author2
    var author2 : some View {
        GroupBox("Author2"){
            VStack{
                TextField("user id ex) 2",text: $author2_user_id) .textFieldStyle(.roundedBorder)
                TextField("name",text: $author2_name) .textFieldStyle(.roundedBorder)
                TextField("score ex) 1000",text: $author2_accumulate_score) .textFieldStyle(.roundedBorder)
            }
        }
    }
    // author3
    var author3 : some View {
        GroupBox("Author3"){
            VStack{
                TextField("user id ex) 3",text: $author3_user_id) .textFieldStyle(.roundedBorder)
                TextField("name",text: $author3_name) .textFieldStyle(.roundedBorder)
                TextField("score ex) 1000",text: $author3_accumulate_score) .textFieldStyle(.roundedBorder)
            }
        }
    }
    // author4
    var author4 : some View {
        GroupBox("Author4"){
            VStack{
                TextField("user id ex) 4",text: $author4_user_id) .textFieldStyle(.roundedBorder)
                TextField("name",text: $author4_name) .textFieldStyle(.roundedBorder)
                TextField("score ex) 1000",text: $author4_accumulate_score) .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    // Challenge_date_time
    var start_datePicker : some View {
        GroupBox("Start Date"){
            DatePicker("start_date", selection: $contestCreateViewModel.contest.challenge_date_time.start_time, in: Date()...)
                       .datePickerStyle(WheelDatePickerStyle())
                       .labelsHidden()
        }
    }
    var end_datePicker : some View {
        GroupBox("End Date"){
            DatePicker("end_date", selection: $contestCreateViewModel.contest.challenge_date_time.end_time, in: Date()...)
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

struct PostContest : Encodable {
    let authors : [Author]
    let name : String
    let challenge_date_time : PostChallengeDate
    let questions : [Int]
    
}
struct PostChallengeDate : Encodable {
    let start_time : String
    let end_time : String
    
}
