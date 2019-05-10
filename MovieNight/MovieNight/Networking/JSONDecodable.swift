//
//  JSONDecodable.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation


protocol JSONDecodable {
    /// Instantiates an instance of the conforming type with a JSON dictionary
    ///
    /// Returns `nil` if the JSON dictionary does not contain all the values
    /// needed for instantiation of the conforming type
    init?(json: [String: Any])
}
