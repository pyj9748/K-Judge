//
//  ContestInfoView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/27.
//

import SwiftUI
import Alamofire
import SwiftyJSON
struct ContestInfoView: View {
    @Binding var challenge : Challenge
    @StateObject var contestInfoViewModel = ContestInfoViewModel()
    
    var body: some View {
        
        VStack{
            Text("").onAppear(){
                contestInfoViewModel.participationList = contestInfoViewModel.getParticipationList(challengeId: challenge.id)
                
                
            }
            // 참가자 수
            Text("참가자 수는 \(contestInfoViewModel.participationList.count)명")
            ScrollView{
                // 참가자 List
                ForEach(contestInfoViewModel.participationList, id: \.participation_id){ item in
                    HStack{
                        
                            HStack(spacing: 10){
                                Image(systemName: "person.crop.circle")
                                    .font(.largeTitle)
                                    
                                
                                VStack(alignment:.leading){
                                    Text("참가 번호 : \(String(item.participation_id))").foregroundColor(Color("DefaultTextColor"))
                                    Text("이름 : \(String(item.name))").foregroundColor(Color("DefaultTextColor"))
                                    Text("점수 : \(String(item.challenge_score))").foregroundColor(Color("DefaultTextColor"))
                                  
                                }
                            }//.padding(.horizontal)
                           
                        
                        Spacer()
                    }.padding(3)
                        .border(width: 0.6, edges: [.bottom], color: Color("DefaultTextColor"))
                   
                }
            }
          
           
        }
    }
}




struct ContestInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ContestInfoView(challenge: .constant(Challenge(id: 1, name: "name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)))
    }
}


// View Model
class ContestInfoViewModel :ObservableObject {
    
    @Published var participationList = [Participation]()
    
}

extension ContestInfoViewModel {
    func getParticipationList(challengeId : Int) -> [Participation] {
        
        
        var list :[Participation] = []
        let parameters : [String: Any] = [
                       "page": 0,
                       "size": 300  // 여기는 한번에 가져올 문제 개수 값
        ]
        // api call - 대회 목록조회
        let url = "\(baseURL):8080/api/challenges/\(challengeId)/participations"
               AF.request(url,
                          method: .get,
                          parameters:parameters,
                          encoding: URLEncoding.default,
                          headers: ["Content-Type":"application/json", "Accept":"application/json"])
                   .validate(statusCode: 200..<300)
                   .responseJSON { response in
                       //여기서 가져온 데이터를 자유롭게 활용하세요.
                       switch response.result{
                       case.success(let value):
                           print(response)
                           let json = JSON(value)
                           let dataList = json["data"].array
                           for i in (dataList?.indices)! {
                               let data = json["data"].arrayValue[i]
                            
                               let participation = Participation(participation_id: data["participation_id"].intValue, user_id: data["user_id"].intValue, name: data["name"].stringValue, challenge_score: data["challenge_score"].intValue)
                               
                               list.append(participation)
                           }
                           self.participationList = list
                       case.failure(let error) :
                           print(error.localizedDescription)
                       }
               }
        return list
        
        
    }
    
    
}

struct Participation : Encodable {
    let participation_id : Int
    let user_id : Int
    let name : String
    let challenge_score : Int
}
