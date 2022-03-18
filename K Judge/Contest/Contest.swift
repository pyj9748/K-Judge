//
//  Contest.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import Foundation

// Model
struct Contest : Codable, Identifiable{
    var id : UUID
    var authors : [Author]
    var name : String
    var challenge_date_time : Challenge_date_time
    var questions : [Int]
    
}

// contest 작성자
struct Author : Codable, Identifiable,Hashable{
    var id : UUID
    var user_id : String
    var name : String
    var accumulate_score : String
    
}
// contest 대회 기간
struct Challenge_date_time : Codable {
    var start_time : String
    var end_time: String
}
