//
//  WebResources.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import Foundation

// Resource for getting the schools from API
struct SchoolsResource {
    let url: URL
    let resource: Resource<SchoolViewModel>
    // Initialise the resource, it will decode an array of SchoolViewModel
    init(url: String = kNYCSCHOOLS){
        self.url = URL(string: url)!
        self.resource = Resource<SchoolViewModel>(url: self.url) { data in
            let schoolsVM = try? JSONDecoder().decode([SchoolViewModel].self, from: data)
            return schoolsVM
        }
    }
}

// Resource for getting the SAT scores from API
struct ScoresResource {
    let url: URL
    let resource: Resource<ScoresViewModel>
    // Initialise the resource, it will decode an array of SchoolViewModel
    init(schoolDBN: String){
        self.url = URL(string: kSATSCORES + schoolDBN)!
        self.resource = Resource<ScoresViewModel>(url: self.url) { data in
            let scoresVM = try? JSONDecoder().decode([ScoresViewModel].self, from: data)
            return scoresVM
        }
    }
}
