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
    @State var showAlert = false
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
        GroupBox("대회명 수정"){
            TextField("대회 이름을 입력하세요.", text:self.$name )
                .textFieldStyle(.roundedBorder)
        }
    }
    // Challenge_date_time
    var start_datePicker : some View {
        GroupBox("대회 시작 시각 설정"){
            DatePicker("start_date", selection: self.$start, in: Date()...)
                       .datePickerStyle(GraphicalDatePickerStyle())
                       .labelsHidden()
        }
    }
    var end_datePicker : some View {
        GroupBox("대회 종료 시각 설정"){
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
//                    if json["error"]["status"] != NULL {
//
//                        showAlert = true
//                        return
//                    }
                   
                default:
                    showAlert = true
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
        }) .alert("대회의 주최자가 아닙니다.", isPresented: $showAlert) {
            Button("확인"){}
        } message: {
            Text("대회의 주최자만 대회 정보를 수정 가능합니다.😘")
        }
            
       
        
    }
}


struct PutInfo :Encodable{
    let name : String
    let challenge_date_time : PostChallengeDate
    
}
