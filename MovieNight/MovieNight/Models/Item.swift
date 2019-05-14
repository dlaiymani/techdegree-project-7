//
//  Item.swift
//  MovieNight
//
//  Created by davidlaiymani on 11/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

// The Item protocol
protocol Item: NSObject, JSONDecodable {
    var name: String { get }
}

// The user will be able to choose among ParameterType
enum ParameterType: String {
    case genre = "Genres"
    case certification = "Certifications"
    case popularActors = "Popular Actors"
}

// Preference of the users
struct Preference {
    let name: ParameterType
    let numberOfParametersToSelect: Int

