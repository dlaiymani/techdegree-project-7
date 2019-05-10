//
//  Result.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

enum Result<T,U> where U: Error {
    case success(T)
    case failure(U)
}
