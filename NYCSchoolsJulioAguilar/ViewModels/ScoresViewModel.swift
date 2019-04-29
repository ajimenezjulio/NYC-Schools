//
//  ScoresViewModel.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import Foundation

// Class to keep the SATScores
class SATScores {
    // It's necesary to create a init for the structure, if not it's impossible to access it if no data was retrieved
    private(set) var scoresViewModel = ScoresViewModel()
    
    func fetchScores(schoolVM: SchoolViewModel, completion: @escaping (String?)->() ) {
        let scores = ScoresResource(schoolDBN: schoolVM.dbn)
        self.scoresViewModel.schoolViewModel = schoolVM
        Webservice().load(resource: scores.resource) { result in
            if let scores = result?.first {
                self.scoresViewModel = scores
                // Do it again, structures are created each time
                self.scoresViewModel.schoolViewModel = schoolVM
                completion(nil)
            } else {
                DispatchQueue.main.async {
                    completion("We're sorry, there's no scores available. Please try later")
                }
            }
        }
    }
}



// Model for the SAT scores of a school
struct ScoresViewModel: Decodable {
    let takers: String
    let reading: String
    let math: String
    let writing: String
    var schoolViewModel: SchoolViewModel?
    
    
    // Personalise the decoding keys
    private enum CodingKeys: String, CodingKey {
        case takers = "num_of_sat_test_takers"
        case reading = "sat_critical_reading_avg_score"
        case math = "sat_math_avg_score"
        case writing = "sat_writing_avg_score"
    }
    
    init() {
        self.takers = kNoDataSymbol
        self.reading = kNoDataSymbol
        self.math = kNoDataSymbol
        self.writing = kNoDataSymbol
    }
}
