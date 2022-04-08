//
//  Submit.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import Foundation

// Model
struct Submit :Encodable {
    
    var source_code : String
    
    var programming_language : String
    var problem_id : Int
}

enum Language {
    case JAVA
    case CPP
    case C
    var string: String{
        switch self{
        case .JAVA:
            return "JAVA"
        case .CPP:
            return "CPP"
        case .C:
            return "C"
        }
    }
}


