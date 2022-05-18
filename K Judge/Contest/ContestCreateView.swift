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
    // 문제명 공백
    @State var showTitleAlert = false
    // 출제 문제 배열 공백
    @State var showQuestionsAlert = false
    // 대회 시작 날짜가 지금보다 빠르다
    @State var showStartAlert = false
    // 대회 종료 날짜가 시작날짜보다 빠르다
    @State var showEndAlert = false
    
    @State var showSuccess = false
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
            
            // 문제명 공백
            guard self.$contestCreateViewModel.contest.name.wrappedValue != ""
            else {
                self.showTitleAlert = true
                return
            }
            
            // 출제 문제 배열 공백
            guard self.$multiSelection.wrappedValue.count != 0
            else {
                showQuestionsAlert = true
                return
            }

            // 대회 시작 날짜가 지금보다 빠르다
            guard self.$contestCreateViewModel.contest.challenge_date_time.start_time.wrappedValue > Date.now
            else {
                self.showStartAlert = true
                return
            }
            // 대회 종료 날짜가 시작날짜보다 빠르다
            guard self.$contestCreateViewModel.contest.challenge_date_time.end_time.wrappedValue > self.$contestCreateViewModel.contest.challenge_date_time.start_time.wrappedValue
            else {
                self.showEndAlert = true
                return
            }
            
            // 문제의 값이 잘 들어갔는지

            
            
            
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
            
           // print("create challnege : ",token)
            
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
                showSuccess = true
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
            .alert("대회이름 공백오류", isPresented: $showTitleAlert) {
                Button("확인"){}
            } message: {
                Text("대회 이름은 공백일 수 없습니다.")
            }
            .alert("출제문제 배열 공백오류", isPresented: $showQuestionsAlert) {
                Button("확인"){}
            } message: {
                Text("적어도 한 문제이상 출제해야 합니다.")
            }
            .alert("대회시작 값 오류", isPresented: $showStartAlert) {
                Button("확인"){}
            } message: {
                Text("대회시작은 현재보다 미래시각이어야 합니다.")
            }
            .alert("대회종료 값 오류", isPresented: $showEndAlert) {
                Button("확인"){}
            } message: {
                Text("대회종료는 대회시작보다 미래시각이어야 합니다.")
            }.alert("성공", isPresented: $showSuccess) {
                Button("확인"){}
            } message: {
                Text("대회생성 완료")
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
