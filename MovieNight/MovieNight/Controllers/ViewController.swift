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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genres = [Genre(json: ["id": 28,"name": "Action"]), Genre(json: ["id": 12,"name": "Adventure"])] as! [Genre]
        
        print(genres[0].name)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        if genres.count > 0 {
            
            // delete duplicate
            let genresUnique = genres.removeDuplicates()
            certifications = certifications.removeDuplicates()
            print(genresUnique.count)
            print(certifications.count)
            
            for genre in genresUnique {
                print(genre.name)
            }
            
        }

    }

    
    @IBAction func userButtonTapped(_ sender: UIButton) {
        let image = UIImage(named: "bubble-selected")
       
        sender.setBackgroundImage(image, for: .normal)
        sender.isUserInteractionEnabled = false
    }
    
    @IBAction func viewResults(_ sender: UIButton) {
        client.discoverMovies(genres: genres, certifications: certifications) { [weak self] result in
            switch result {
            case .success(let movies):
                print(movies.count)
                //self?.dataSource.updateData(certification)
                //self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

