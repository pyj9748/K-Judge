//
//  ContestItemViewModel.swift
//  K Judge
//
//  Created by young june Park on 2022/03/13.
//

import Foundation
import SwiftUI

// View Model
class ContestItemViewModel :ObservableObject {
    
    @Published var contest = Contest(id : UUID(),authors: [], name: "name", challenge_date_time: Challenge_date_time(start_time: "", end_time: "" ), questions: [])
    
}

extension ContestItemViewModel {
    
    
}
