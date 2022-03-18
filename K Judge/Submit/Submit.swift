//
//  Submit.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import Foundation

// Model
struct Submit :Codable {
    
    var source_code : String
    
    var programming_language : String
    
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
            return "C++"
        case .C:
            return "C"
        }
    }
}

