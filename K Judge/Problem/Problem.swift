//
//  Problem.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import Foundation

let baseURL : String = "http://54.95.66.103:8080"

//Model

struct Problem : Codable{
    var id : String
    var name : String
    var description :Description
    var limit : Limit
    var score : String
    // var num_of_failed : Int
    //var num_of_submits : Int
    //var num_of_success : Int
    // var created_at : Date
    // var updated_at : Date
}
extension Problem {
    func toJSON() -> Dictionary<String,Any> {
        return [
            "name" : self.name as Any,
            "description" : self.description.toJSON() as Any,
            "limit" : self.limit.toJSON() as Any,
            "score" : self.score as Any
        ]
    }
}
struct ResponseProblem : Codable {
    var id : Int
    var name : String
    var description : String
    var input_description : String
    var output_description : String
    var score : String
    
}

struct Description : Codable {
    var description : String
    var input_description : String
    var output_description : String
}
extension Description {
    func toJSON() -> Dictionary<String,Any> {
        return [
            "description" : self.description as Any,
            "input_description" : self.input_description as Any,
            "output_description" : self.output_description as Any
        ]
    }
}

struct Limit : Codable{
    var memory : String
    var time : String
}

extension Limit {
    func toJSON() -> Dictionary<String,Any> {
        return [
            "memory" : self.memory as Any,
            "time" : self.time as Any
        ]
    }
}

struct ProblemCatalogs :Codable,Identifiable{
    var id : String
    var name : String
    var score : String
}
