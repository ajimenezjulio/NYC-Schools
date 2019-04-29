//
//  WebService.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import Foundation

// Generic Resource, it will handle any type through injection of dependencies
struct Resource<T> {
    let url: URL
    let parse: (Data) -> [T]?
}

final class Webservice {
    // Function to load the data from the server
    func load<T>(resource: Resource<T>, completion: @escaping ([T]?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    completion(resource.parse(data))
                }
            } else {
                completion(nil)
            }
            }.resume()
    }
    
}
