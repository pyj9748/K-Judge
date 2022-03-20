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
    
    @Published var contest = Contest(id :"id",authors: [], name: "name", challenge_date_time: Challenge_date_time(start_time: Date(), end_time: Date() ), questions: [])
    
}

extension ContestItemViewModel {
    
    
}
