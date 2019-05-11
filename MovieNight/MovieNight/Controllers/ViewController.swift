//
//  ViewController.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var user1Button: UIButton!
    @IBOutlet weak var user2Button: UIButton!
    
    var genres = [Genre]()
    var certification = [Certification]()
    
    var testVC = "Yo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(testVC)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        if genres.count > 0 {
            print(genres.count)
            print(certification.count)
        }

    }

    
    @IBAction func userButtonTapped(_ sender: UIButton) {
        let image = UIImage(named: "bubble-selected")
       
        sender.setBackgroundImage(image, for: .normal)
        sender.isUserInteractionEnabled = false
    }
    
}

