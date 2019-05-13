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
    
    var preferences = [ParemeterType.genre]
    var selectedParameters = [Int]()
    var numberOfParametersToSelect = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tintColor = .blue
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
                    selectedParameters.append(indexPath.row)
            } else {
                cell.accessoryType = .none
                let index = selectedParameters.firstIndex(of: indexPath.row)
                if let index = index {
                    selectedParameters.remove(at: index)
                }
            }
            
            if selectedParameters.count == 0 {
                doneButton.isEnabled = false
            } else {
                doneButton.isEnabled = true
            }
        }
    }
    
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceCell", for: indexPath)
        
        cell.accessoryType = .none
        
        return cell
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
