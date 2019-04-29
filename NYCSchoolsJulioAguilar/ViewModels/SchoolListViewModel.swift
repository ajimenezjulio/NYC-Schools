//
//  SchoolListViewModel.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import Foundation
import UIKit

// Model that will keep all the NYC schools
class SchoolListViewModel {
    private(set) var schoolViewModels = [SchoolViewModel]()
    private(set) var filteredSchools = [SchoolViewModel]()
    
    // Set the schoolViewModels
    func setSchoolViewModels(with viewModels: [SchoolViewModel]) {
        self.schoolViewModels = viewModels
    }
    
    func fetchSchools(completion: @escaping (String?) -> () ) {
        let schools = SchoolsResource.init()
        Webservice().load(resource: schools.resource) { [weak self] result in
            if let schoolsVM = result {
                self?.schoolViewModels = schoolsVM
                completion(nil)
            } else {
                DispatchQueue.main.async {
                    completion("We're sorry, there's no data available. Please try later")
                }
            }
        }
    }
    
    func filterSchools(searchText: String) {
        guard searchText != "" else {
            self.filteredSchools = self.schoolViewModels
            return
        }
        self.filteredSchools = self.schoolViewModels.filter({ (school) -> Bool in
            return school.name.lowercased().contains(searchText.lowercased())
        })
    }
}


// Model for a single school, it implements the decodable protocol for the parsing process
struct SchoolViewModel: Decodable {
    let name: String
    let interest: String
    let city: String
    let state: String
    let dbn: String
    let overview: String
    var logo: UIImage?
    
    // Personalise the decoding keys and tell the protocol that logo isn't part of the JSON
    private enum CodingKeys: String, CodingKey {
        case name = "school_name"
        case interest = "interest1"
        case city
        case state = "state_code"
        case dbn
        case overview = "overview_paragraph"
    }
}
