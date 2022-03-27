//
//  ContestCreateViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import Foundation
import Alamofire
import SwiftyJSON

// View Model
class ContestCreateViewModel :ObservableObject {
    
    @Published var contest = Contest(id : "0", authors: [], name: "name", challenge_date_time: Challenge_date_time(start_time: Date(), end_time: Date() ), questions: [])
    
}

// api call - contest 생성
extension ContestCreateViewModel {
    
    
    
    func getStartDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        return dateFormatter.string(from: self.contest.challenge_date_time.start_time)
        
    }
    func getEndDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        return dateFormatter.string(from: self.contest.challenge_date_time.end_time)
    
    }
    
    
}

