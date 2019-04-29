//
//  _019_04_26_JulioCesarAguilar_NYCSchoolsTests.swift
//  2019-04-26-JulioCesarAguilar-NYCSchoolsTests
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import XCTest
@testable import NYCSchoolsJulioAguilar

class testModels {
    private var schools = """
[
    {   \"city\": \"Manhattan\",
        \"dbn\": \"02M260\",
        \"interest1\": \"Humanities & Interdisciplinary\",
        \"overview_paragraph\": \"Students who are prepared for college must have an education that encourages them to take risks as they produce and perform. Our college preparatory curriculum develops writers and has built a tight-knit community. Our school develops students who can think analytically and write creatively. Our arts programming builds on our 25 years of experience in visual, performing arts and music on a middle school level. We partner with New Audience and the Whitney Museum as cultural partners. We are a International Baccalaureate (IB) candidate school that offers opportunities to take college courses at neighboring universities.\",
        \"school_name\": \"Clinton School Writers & Artists, M.S. 260\",
        \"state_code\": \"NY\"
    },
    {
        \"city\": \"Brooklyn\",
        \"dbn\": \"21K728\",
        \"interest1\": \"Humanities & Interdisciplinary\",
        \"overview_paragraph\": \"The mission of Liberation Diploma Plus High School, in partnership with CAMBA, is to develop the student academically, socially, and emotionally. We will equip students with the skills needed to evaluate their options so that they can make informed and appropriate choices and create personal goals for success. Our year-round model (trimesters plus summer school) provides students the opportunity to gain credits and attain required graduation competencies at an accelerated rate. Our partners offer all students career preparation and college exposure. Students have the opportunity to earn college credit(s). In addition to fulfilling New York City graduation requirements, students are required to complete a portfolio to receive a high school diploma.\",
        \"school_name\": \"Liberation Diploma Plus High School\",
        \"state_code\": \"NY\",
    },
    {
        \"city\": \"Bronx\",
        \"dbn\": \"08X282\",
        \"interest1\": \"Science & Math\",
        \"overview_paragraph\": \"The WomenÂ’s Academy of Excellence is an all-girls public high school, serving grades 9-12. Our mission is to create a community of lifelong learners, to nurture the intellectual curiosity and creativity of young women and to address their developmental needs. The school community cultivates dynamic, participatory learning, enabling students to achieve academic success at many levels, especially in the fields of math, science, and civic responsibility. Our scholars are exposed to a challenging curriculum that encourages them to achieve their goals while being empowered to become young women and leaders. Our Philosophy is GIRLS MATTER!\",
        \"school_name\": \"Women's Academy of Excellence\",
        \"state_code\": \"NY\",
    }
]
"""
    private(set) var schoolsVM: [SchoolViewModel]?
    
    init() {
        let data = Data(schools.utf8)
        self.schoolsVM = try! JSONDecoder().decode([SchoolViewModel].self, from: data)
    }
}

class _019_04_26_JulioCesarAguilar_NYCSchoolsTests: XCTestCase {
    
    func testLoadingSchoolsResponse() {
        // Expectation that will help to wait some time until the API can retrieve the information
        let expectation = self.expectation(description: "API Response Parse Expectation")
        
        let schools = SchoolsResource.init()
        
        Webservice().load(resource: schools.resource) { result in
            XCTAssertNotNil(result, "Should work, and retrieve data")
            guard let schoolVM: SchoolViewModel = result?.first else {
                XCTFail("Should parse the data into a SchoolViewmodel")
                return
            }
            XCTAssertNotNil(schoolVM.name, "Should parse indiviudal keys")
            XCTAssertFalse(schoolVM.name == "", "Should retrieve a school name")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 8, handler: nil)
    }
    
    func testLoadingSchoolShouldFailed() {
        let expectation = self.expectation(description: "API Response Parse Expectation")
        
        let failedURL = "https://data.cityofnewyork.us/s3k6-pzi2.json"
        let schools = SchoolsResource(url: failedURL)
        
        Webservice().load(resource: schools.resource) { result in
            XCTAssertNil(result, "Shouldn't work, it must have nothing")
            if let _: SchoolViewModel = result?.first {
                XCTFail("Shouldn't parse the data into a SchoolViewmodel")
                return
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadingSchoolDetailResponse() {
        // Expectation that will help to wait some time until the API can retrieve the information
        let expectation = self.expectation(description: "API Response Parse Expectation")
        
        let validDBN = "21K728"
        let scores = ScoresResource.init(schoolDBN: validDBN)
        
        Webservice().load(resource: scores.resource) { result in
            XCTAssertNotNil(result, "Should work, and retrieve data")
            guard let scoresVM: ScoresViewModel = result?.first else {
                XCTFail("Should parse the data into a ScoresViewModel")
                return
            }
            XCTAssertNotNil(scoresVM.takers, "Should parse indiviudal keys")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 8, handler: nil)
    }

    func testLoadingSchoolDetailShouldFailed() {
        // Expectation that will help to wait some time until the API can retrieve the information
        let expectation = self.expectation(description: "API Response Parse Expectation")
        
        let invalidDBN = "AAAAA"
        let scores = ScoresResource.init(schoolDBN: invalidDBN)
        
        Webservice().load(resource: scores.resource) { result in
            XCTAssertNotNil(result, "Should work and retrieve something empty")
            
            guard let _ = result?.first else {
                expectation.fulfill()
                return
            }
            XCTFail("It shouldn't be anything inside result")
        }
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchBar() {
        let testModel = testModels.init()
        let schoolsVM = SchoolListViewModel()
        
        schoolsVM.setSchoolViewModels(with: testModel.schoolsVM!)
        // Testing just one result must remain (Woman's Academy)
        schoolsVM.filterSchools(searchText: "Wo")
        XCTAssertTrue(schoolsVM.filteredSchools.count == 1, "Should be just one school")
        XCTAssertTrue(schoolsVM.filteredSchools.first?.name == "Women's Academy of Excellence", "Should be the Woman's Academy")
        // Testing two results
        schoolsVM.filterSchools(searchText: "W")
        XCTAssertTrue(schoolsVM.filteredSchools.count == 2, "Should be two schools")
        XCTAssertTrue(schoolsVM.filteredSchools.first?.name == "Clinton School Writers & Artists, M.S. 260", "Should be the Clinton School")
        // Testing three or more results
        schoolsVM.filterSchools(searchText: "C")
        XCTAssertTrue(schoolsVM.filteredSchools.count == 3, "Should be three schools")
        XCTAssertTrue(schoolsVM.filteredSchools.last?.name == "Women's Academy of Excellence", "Should be the Woman's Academy")
    }
}
