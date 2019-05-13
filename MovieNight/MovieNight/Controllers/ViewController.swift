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
    @IBOutlet weak var viewResultsButton: UIButton!
    @IBOutlet weak var preferencesButton: UIBarButtonItem!
    
    lazy var client: ImdbClient = {
        return ImdbClient(configuration: .default)
    }()
    
    let userDefaults = UserDefaults.standard
    var selectedParameters: [Bool]?
    var genres = [Genre]()
    var certifications = [Certification]()
    var popularActors = [Actor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedParameters = userDefaults.object(forKey: "Preferences") as? [Bool] ?? [true,false,false]
        
    //    genres = [Genre(json: ["id": 28,"name": "Action"]), Genre(json: ["id": 12,"name": "Adventure"])] as! [Genre]
     //   certifications = [Certification(json: ["certification": "NC-17"])] as! [Certification]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
            // delete duplicate
            genres = genres.removeDuplicates()
            certifications = certifications.removeDuplicates()
            popularActors = popularActors.removeDuplicates()
        
        if (!user1Button.isUserInteractionEnabled && !user2Button.isUserInteractionEnabled) {
            viewResultsButton.isEnabled = true
        } else {
            viewResultsButton.isEnabled = false
        }
        
        if (!user1Button.isUserInteractionEnabled && user2Button.isUserInteractionEnabled) || (user1Button.isUserInteractionEnabled && !user2Button.isUserInteractionEnabled) {
            preferencesButton.isEnabled = false
        } else {
            preferencesButton.isEnabled = true
        }
    }

    
    @IBAction func userButtonTapped(_ sender: UIButton) {
        let image = UIImage(named: "bubble-selected")
        sender.setBackgroundImage(image, for: .normal)
        sender.isUserInteractionEnabled = false
    }
    
    @IBAction func viewResults(_ sender: UIButton) {
        
    }
    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        reinitButtons()
    }
    
    
    func reinitButtons() {
        let image = UIImage(named: "bubble-empty")
        user1Button.setBackgroundImage(image, for: .normal)
        user2Button.setBackgroundImage(image, for: .normal)
        user1Button.isUserInteractionEnabled = true
        user2Button.isUserInteractionEnabled = true
        viewResultsButton.isEnabled = false
        
        genres = [Genre]()
        certifications = [Certification]()
        popularActors = [Actor]()

    }
    
    // MARK: - Navigation
    
    @IBAction func unwindFromPrefs(segue: UIStoryboardSegue) {
        selectedParameters = userDefaults.object(forKey: "Preferences") as? [Bool] ?? [true,false,false]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieListSegue" {
            let listViewController = segue.destination as? MovieListController
            listViewController?.genres = genres
            listViewController?.certifications = certifications
            listViewController?.popularActors = popularActors
        } else if (segue.identifier == "selectionSegueUser1" || segue.identifier == "selectionSegueUser2") {
            var parameters = [ParameterType]()
            
            if selectedParameters![0] {
                parameters.append(ParameterType.genre)
            }
            if selectedParameters![1] {
                parameters.append(ParameterType.certification)
            }
            if selectedParameters![2] {
                parameters.append(ParameterType.popularActors)
            }

            
            let navController = segue.destination as! UINavigationController
            let selectViewController = navController.topViewController as! SelectParametersController
            selectViewController.preferences = parameters
        }
    }
    
}

