//
//  PendingOperation.swift
//  MovieNight
//
//  Created by davidlaiymani on 12/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class PendingOperation {
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()
    
    
}
