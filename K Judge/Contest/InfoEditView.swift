//
//  InfoEditView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/27.
//

import SwiftUI
import Alamofire
import SwiftyJSON
struct InfoEditView: View {
    
    //  정부수정은 대회 시작 전에만
    @State var showNow = false
    // 주최자가 아닌 경우
    @State var showAlert = false
    // 성공
    @State var showSuccess = false
    // 문제명 공백
    @State var showTitleAlert = false
 
    // 대회 시작 날짜가 지금보다 빠르다
    @State var showStartAlert = false
    // 대회 종료 날짜가 시작날짜보다 빠르다
    @State var showEndAlert = false
    
 
    @AppStorage("token") var token: String = (UserDefaults.standard.string(forKey: "token") ?? "")
    @Binding var challengeId : Int
    @State var name : String
    @State var start : Date
    @State var end : Date
    var body: some View {
       
        ScrollView{
            VStack{
                nameTextField
                start_datePicker
                end_datePicker
            }    .navigationBarTitle("Edit Info",displayMode:.inline)
                .toolbar(content: {
                    editBtn
                })
        }
        
    }
}

struct InfoEditView_Previews: PreviewProvider {
    static var previews: some View {
        InfoEditView(challengeId: .constant(1 ),name: "name",start: Date() , end: Date())
    }
}

// Info Edit section
extension InfoEditView {
    
    // Name
    var nameTextField : some View{
        
        VStack(alignment : .leading){
            Text("대회명 수정")
            TextField("대회 이름을 입력하세요.", text:self.$name )
                .textFieldStyle(.roundedBorder)
        }
           
    }
    // Challenge_date_time
    var start_datePicker : some View {
      
        VStack(alignment : .leading){
            Text("대회시작")
            DatePicker("start_date", selection: self.$start, in: Date()...)
                       .datePickerStyle(GraphicalDatePickerStyle())
                       .labelsHidden()
        }
            
     
    }
    var end_datePicker : some View {
      
        VStack(alignment : .leading){
            Text("대회종료")
            DatePicker("end_date", selection: self.$end, in: Date()...)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
        }
           
    
    }

}


// 정보 수정 버튼
extension InfoEditView {
  
    var editBtn : some View {
        Button(action: {
           
            // 대회 수정 시간
          
            
            
            // 문제명 공백
            guard self.$name.wrappedValue != ""
            else {
                self.showTitleAlert = true
                return
            }

            // 대회 시작 날짜가 지금보다 빠르다
            guard self.$start.wrappedValue > Date.now
            else {
                self.showStartAlert = true
                return
            }
            // 대회 종료 날짜가 시작날짜보다 빠르다
            guard self.$end.wrappedValue > self.$start.wrappedValue
            else {
                self.showEndAlert = true
                return
            }
            
            
            
               
            // api 콜
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            let startTime = dateFormatter.string(from: self.start)
            let endTime = dateFormatter.string(from: self.end)
            let editInfo = PutInfo(name: name, challenge_date_time: PostChallengeDate(start_time: startTime, end_time: endTime))

            // Header
            let headers : HTTPHeaders = [
                        "Content-Type" : "application/json","Authorization": "Bearer \(token)" ]
            
            AF.request("\(baseURL):8080/api/challenges/\(challengeId)/info",
                       method: .put,
                       parameters: editInfo,
                       encoder: JSONParameterEncoder.default,headers:  headers).response { response in
                debugPrint(response)
            }.responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["error"]["status"].intValue == 403 {
                        showAlert = true
                       
                        return
                    }
                    if json["error"]["status"].intValue == 400 {
                        showNow = true
                       
                        return
                    }
                    else{
                        showSuccess = true
                        return
                    }
                default:
                    return
                }

            })
            
        }, label: {
            HStack {
                    Image(systemName: "highlighter")
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
        }) .alert("대회이름 공백오류", isPresented: $showTitleAlert) {
            Button("확인"){}
        } message: {
            Text("대회 이름은 공백일 수 없습니다.")
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
        } .alert("대회의 주최자가 아닙니다.", isPresented: $showAlert) {
            Button("확인"){}
        } message: {
            Text("대회의 주최자만 대회 정보를 수정 가능합니다.😘")
        } .alert("성공", isPresented: $showSuccess) {
            Button("확인"){}
        } message: {
            Text("대회정보 수정 완료")
        }.alert("대회수정 시각오류", isPresented: $showNow) {
            Button("확인"){}
        } message: {
            Text("대회수정은 대회시작 전에만 가능합니다.")
        }
            
       
        
    }
}


struct PutInfo :Encodable{
    let name : String
    let challenge_date_time : PostChallengeDate
    
}
