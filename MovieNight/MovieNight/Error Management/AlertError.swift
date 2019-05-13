//
//  AlertError.swift
//  MovieNight
//
//  Created by davidlaiymani on 13/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit


class AlertError {
    
    var error: APIError
    weak var viewController: UIViewController?
    
    init(error: APIError, on viewController: UIViewController?) {
        self.error = error
        self.viewController = viewController
    }
    
    
    // Display an alertView with a given title and a givent message
    func alert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.viewController?.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(action)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    
    // Handle the API errors
    func displayAlert() {
        switch self.error {
        case .requestFailed:
            alert(withTitle: "Network connection error", andMessage: "Please check your network connection")
        case .invalidData, .jsonConversionFailure:
            alert(withTitle: "Data error", andMessage: "Data format seems incorrect")
        case .responseUnsuccessful:
            alert(withTitle: "Bad server response", andMessage: "The server's response seems incorrect")
        case .jsonParsingFailure:
            alert(withTitle: "No match", andMessage: "Sorry, no movie corresponds to your request")
        }
    }
}
