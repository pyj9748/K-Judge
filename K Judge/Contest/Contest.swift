//
//  Contest.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import Foundation

// Model
struct Contest : Codable, Identifiable{
    var id : String
    var authors : [Author]
    var name : String
    var challenge_date_time : Challenge_date_time
    var questions : [Int]
    
}

// contest 작성자
struct Author : Codable, Hashable{
    //var id : UUID
    var user_id : String
    var name : String
    var accumulate_score : String
    
}

extension Contest {
    func toJSON() -> Dictionary<String,Any> {
        return [
            //"id" : self.id as Any,
            "authors" : self.authors.map({
                $0.toJSON()
            }) as Any,
            "name" : self.name as Any,
            "challenge_date" : self.challenge_date_time.toJSON() as Any,
            "questions" : self.questions as Any
        ]
    }
}

extension Author {
    func toJSON() -> Dictionary<String,AnyObject> {
        return [
            "user_id" : Int(self.user_id)! as AnyObject,
            "name" : self.name as AnyObject,
            "accumulate_score" : Int(self.accumulate_score)! as AnyObject
        ]
    }
}
// contest 대회 기간
struct Challenge_date_time : Codable {
    var start_time : Date
    var end_time: Date
}

extension Challenge_date_time {
    func toJSON() -> Dictionary<String,AnyObject> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        return [
            "start_time" : dateFormatter.string(from: start_time) as AnyObject,
            "end_time" : dateFormatter.string(from: end_time) as AnyObject
        ]
    }
}

