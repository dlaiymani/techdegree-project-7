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
    var preferencesBool = [Bool]()
    var genres = [Genre]()
    var certifications = [Certification]()
    var popularActors = [Actor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferencesBool = userDefaults.object(forKey: "Preferences") as? [Bool] ?? [true,true,false]
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
            navigationController?.navigationBar.barStyle = .black
            updateUsersButtons()
            // Remove duplicate choices
            genres = genres.removeDuplicates()
            certifications = certifications.removeDuplicates()
            popularActors = popularActors.removeDuplicates()
    }

    
    @IBAction func userButtonTapped(_ sender: UIButton) {
        let image = UIImage(named: "bubble-selected")
        sender.setBackgroundImage(image, for: .normal)
        sender.isUserInteractionEnabled = false
    }
    
  
    @IBAction func clearButtonTapped(_ sender: Any) {
        // reset the arrays
        genres = [Genre]()
        certifications = [Certification]()
        popularActors = [Actor]()
        // reset the buttons
        reinitButtons()
    }
    
    
    func updateUsersButtons() {
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
    
    func reinitButtons() {
        let image = UIImage(named: "bubble-empty")
        user1Button.setBackgroundImage(image, for: .normal)
        user2Button.setBackgroundImage(image, for: .normal)
        user1Button.isUserInteractionEnabled = true
        user2Button.isUserInteractionEnabled = true
        viewResultsButton.isEnabled = false

    }
    
    // MARK: - Navigation
    
    @IBAction func unwindFromPrefs(segue: UIStoryboardSegue) {
        preferencesBool = userDefaults.object(forKey: "Preferences") as? [Bool] ?? [true,true,false]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieListSegue" {
            let listViewController = segue.destination as? MovieListController
            listViewController?.genres = genres
            listViewController?.certifications = certifications
            listViewController?.popularActors = popularActors
        } else if (segue.identifier == "selectionSegueUser1" || segue.identifier == "selectionSegueUser2") {
            var preferencesByType = [ParameterType]()
            var preferences = [Preference]()
            
            if preferencesBool[0] {
                preferencesByType.append(ParameterType.genre)
                preferences.append(Preference(name: .genre, numberOfParametersToSelect: 3))
                
            }
            if preferencesBool[1] {
                preferencesByType.append(ParameterType.certification)
                preferences.append(Preference(name: .genre, numberOfParametersToSelect: 3))

            }
            if preferencesBool[2] {
                preferencesByType.append(ParameterType.popularActors)
                preferences.append(Preference(name: .genre, numberOfParametersToSelect: 3))

            }

            let navController = segue.destination as! UINavigationController
            let selectViewController = navController.topViewController as! SelectParametersController
            selectViewController.preferences = preferences
        }
    }
    
}

