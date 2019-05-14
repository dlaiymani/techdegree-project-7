//
//  PreferencesController.swift
//  MovieNight
//
//  Created by davidlaiymani on 13/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class PreferencesController: UITableViewController {
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet var cells: [UITableViewCell]!
    
    var preferences = [ParameterType.genre]
    var selectedParameters = [Bool]()
    var numberOfPreferences = 3
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tintColor = .blue
        
        selectedParameters = userDefaults.object(forKey: "Preferences") as? [Bool] ?? [true,true,false]
        displayPrefs()
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if selectedParameters.count == 0 {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    selectedParameters[indexPath.section] = true
            } else {
                cell.accessoryType = .none
                selectedParameters[indexPath.section] = false
            }
            
            if nothingIsSelected() {
                doneButton.isEnabled = false
            } else {
                doneButton.isEnabled = true
            }
        }
    }
    
    func displayPrefs() {
        for section in 0...numberOfPreferences-1 {
            let pref = selectedParameters[section]
            
            if pref == true {
                cells[section].accessoryType = .checkmark
            } else {
                cells[section].accessoryType = .none
            }
        }
    }
    
    func nothingIsSelected() -> Bool {
        for section in selectedParameters {
            if section == true {
                return false
            }
        }
        return true
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.userDefaults.set(selectedParameters, forKey: "Preferences")
    }
    

}
