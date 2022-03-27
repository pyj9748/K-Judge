//
//  InfoEditView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/27.
//

import SwiftUI
import Alamofire

struct InfoEditView: View {
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
        GroupBox("Name"){
            TextField("Enter Name", text:self.$name )
                .textFieldStyle(.roundedBorder)
        }
    }
    // Challenge_date_time
    var start_datePicker : some View {
        GroupBox("Start Date"){
            DatePicker("start_date", selection: self.$start, in: Date()...)
                       .datePickerStyle(WheelDatePickerStyle())
                       .labelsHidden()
        }
    }
    var end_datePicker : some View {
        GroupBox("End Date"){
            DatePicker("end_date", selection: self.$end, in: Date()...)
                .datePickerStyle(WheelDatePickerStyle())
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

            AF.request("\(baseURL):8082/api/challenges/\(challengeId)/info",
                       method: .put,
                       parameters: editInfo,
                       encoder: JSONParameterEncoder.default).response { response in
                debugPrint(response)
            }
            
        }, label: {
            HStack {
                    Image(systemName: "highlighter")
                    .font(.body)
                    Text("Edit")
                        .fontWeight(.semibold)
                        .font(.body
                        )
                }
                .padding(6)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        })
            
       
        
    }
}


struct PutInfo :Encodable{
    let name : String
    let challenge_date_time : PostChallengeDate
    
}
