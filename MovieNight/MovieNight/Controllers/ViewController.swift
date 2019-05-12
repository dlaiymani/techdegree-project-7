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
    
    lazy var client: ImdbClient = {
        return ImdbClient(configuration: .default)
    }()
    
    var genres = [Genre]()
    var certifications = [Certification]()
    var popularActors = [Actor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   genres = [Genre(json: ["id": 28,"name": "Action"]), Genre(json: ["id": 12,"name": "Adventure"])] as! [Genre]
    //    certifications = [Certification(json: ["certification": "NC-17"])] as! [Certification]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        if genres.count > 0 {
            
            // delete duplicate
            genres = genres.removeDuplicates()
            certifications = certifications.removeDuplicates()
            popularActors = popularActors.removeDuplicates()
            
//            for genre in genres {
//                print(genre.id)
//            }
//
//            for certif in certifications {
//                print(certif.name)
//            }
            
            
        }

    }

    
    @IBAction func userButtonTapped(_ sender: UIButton) {
        let image = UIImage(named: "bubble-selected")
       
        sender.setBackgroundImage(image, for: .normal)
        sender.isUserInteractionEnabled = false
    }
    
    @IBAction func viewResults(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieListSegue" {
            let listViewController = segue.destination as? MovieListController
            listViewController?.genres = genres
            listViewController?.certifications = certifications
            listViewController?.popularActors = popularActors
        }
    }
    
}

