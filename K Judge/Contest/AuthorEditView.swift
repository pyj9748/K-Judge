//
//  AuthorEditView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/27.
//

import SwiftUI
import Alamofire
import SwiftyJSON
struct AuthorEditView: View {
    @State var showAlert = false
    @Binding var challengeId : Int
    
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
    
    @State var authorArr : [Author] = []
    
    var body: some View {
        VStack{
            ScrollView{
              
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
               
            }.padding()
                .navigationBarTitle("Edit Authors",displayMode:.inline)
                   .toolbar(content: {
                       editBtn
                   })
        }
    }
}
// Author Edit section
extension AuthorEditView {
    
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

}

struct AuthorEditView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorEditView(challengeId: .constant(1))
    }
}

// 저자 수정 버튼
extension AuthorEditView {
  
    
    
    var editBtn : some View {
        Button(action: {

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
            authorArr = []
            for i in 0..<numOfAuthors {
                authorArr.append( authorArray[i])
            }
           
            // api 콜
           
            let editAuthor = PutAuthor(authors: authorArr)

            AF.request("\(baseURL):8082/api/challenges/\(challengeId)/authors",
                       method: .put,
                       parameters: editAuthor,
                       encoder: JSONParameterEncoder.default).response { response in
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
                    Image(systemName: "person.2")
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
        }).alert("대회의 주최자가 아닙니다.", isPresented: $showAlert) {
            Button("확인"){}
        } message: {
            Text("대회의 주최자만 대회 정보를 수정 가능합니다.😘")
        }
            
                
       
        
    }
}
struct PutAuthor : Encodable{
    
    let authors : [Author]
}
