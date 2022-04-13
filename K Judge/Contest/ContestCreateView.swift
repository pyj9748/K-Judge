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
  
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @State var showingAlert = false
    @State var questions : String = ""
    @State var multiSelection = Set<String>()
    
    
    @StateObject var contestCreateViewModel = ContestCreateViewModel()
    
    @StateObject var problemListViewModel = ProblemListViewModel()
    
    
    var body: some View {
        //NavigationView{
            VStack{
                ScrollView{
                    VStack{
                        nameTextField

                    }.padding()
                    VStack{
                        questionsListSelect
                    }.padding()
                    VStack{
                        start_datePicker
                        end_datePicker
                    }.padding()
                   
                }.onAppear(){
                    problemListViewModel.problemList = problemListViewModel.getProblemList(token: token)
                    
                }
                
            }
            .navigationBarTitle(" 대회 생성 ",displayMode:.inline)
                .toolbar(content: {
                    createBtn
                })
       // }
    }
}

// 대회 생성 버튼
extension ContestCreateView {
  
    
    
    var createBtn : some View {
        Button(action: {
            print("createBtn")
            // 문제의 값이 잘 들어갔는지
//            guard self.questions.split(separator: ",").map({
//                Int($0)!
//            }) != []
//            else {
//                self.showingAlert = true
//                return
//            }
//
            
            
            
            // api call = create Contest
          
    
            contestCreateViewModel.contest.questions =
            self.$multiSelection.wrappedValue.map({
                Int($0)!
            })
            
//            self.questions.split(separator: ",").map({
//                Int($0)!
//            })
            
            let start = contestCreateViewModel.getStartDate()
            let end = contestCreateViewModel.getEndDate()
            
           
            
            //contestCreateViewModel.createContest(parameters: parameters)
            // Header
            let headers : HTTPHeaders = [
                        "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
            
            let postContest = PostContest( name: contestCreateViewModel.contest.name, challenge_date_time: PostChallengeDate(start_time: start, end_time: end), questions: contestCreateViewModel.contest.questions)
           

            AF.request("\(baseURL):8080/api/challenges",
                       method: .post,
                       parameters: postContest,
                       encoder: JSONParameterEncoder.default,headers: headers).response { response in
                debugPrint(response)
            }
            
            
            
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
        VStack(alignment:.leading){
            Text("대회 이름").font(.headline)
            TextField("Enter Name", text:self.$contestCreateViewModel.contest.name)
                .textFieldStyle(.roundedBorder)
                .border(Color("DefaultTextColor"), width: 2)
        }
    }
    

    
    var questionsListSelect: some View {
        VStack(alignment: .leading){
            
            Text("출제 문제").font(.headline)
            Spacer()
            HStack{
                Spacer()
                NavigationLink(destination: ProblemSelectionView(problemList: $problemListViewModel.problemList , multiSelection: $multiSelection),label: {
                    
                    Text("출제 문제 선택하러 가기")
                        .padding()
                        //.frame(width: 380, height: 100, alignment: .center)
                       
                       // .background(Color("KWColor3"))
                        .border(Color("DefaultTextColor"), width: 2)
                        .cornerRadius(6)
                })
                Spacer()
            }
          
            //Text("출제 문제 : \(multiSelection.description)")
        }
       
    }
    

    // Challenge_date_time
    var start_datePicker : some View {
        VStack(alignment:.leading){
            Text("대회 시작").font(.headline)
            DatePicker("start_date", selection: $contestCreateViewModel.contest.challenge_date_time.start_time, in: Date()...)
                       .datePickerStyle(GraphicalDatePickerStyle())
                       .labelsHidden()
        }
    }
    var end_datePicker : some View {
        VStack(alignment:.leading){
            Text("대회 종료").font(.headline)
            DatePicker("end_date", selection: $contestCreateViewModel.contest.challenge_date_time.end_time, in: Date()...)
                .datePickerStyle(GraphicalDatePickerStyle())
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
   
    let name : String
    let challenge_date_time : PostChallengeDate
    let questions : [Int]
    
}
struct PostChallengeDate : Encodable {
    let start_time : String
    let end_time : String
    
}
