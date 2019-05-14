//
//  SelectParametersController.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

// The same controller is used for the differents parameters
class SelectParametersController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var nummberOfSelectedItemsLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    lazy var client: ImdbClient = {
        return ImdbClient(configuration: .default)
    }()
    
    lazy var dataSource: SelectParametersDataSource = {
        return SelectParametersDataSource(data: [])
    }()
    
    var selectedParameters = [Int]()
    var preferences = [Preference]()
    var parameterNumber = 0
    var numberOfParametersToSelect = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        configureView()
        updateTableView()
    }
    
    
    // MARK: - Update view functions
    // Send the appropriate request and update the tableview to display the results
    func updateTableView() {
        
        let currentPreference = preferences[parameterNumber]
        configureView(for: currentPreference)
        
        switch currentPreference.name {
        case .genre:
            
            client.searchGenres() { [weak self] result in
                self?.updateCells(for: currentPreference, result: result)
            }
        case .certification:
            client.searchCertifications() { [weak self] result in
                self?.updateCells(for: currentPreference, result: result)
            }
        case .popularActors:
            
            client.searchPopularActors() { [weak self] result in
                self?.updateCells(for: currentPreference, result: result)
            }
        }
    }
    
    // Update the datasource and then the cells
    func updateCells<T>(for preference: Preference, result: Result<T, APIError>) {
        switch result {
        case .success(let resultArray):
            dataSource.appendData(resultArray as! [Item])
            tableView.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        case .failure(let error):
            let alertError = AlertError(error: error, on: self)
            alertError.displayAlert()
        }
        
    }
    
    // Display the correct number title and number of parameters to select
    func configureView(for preference: Preference) {
        numberOfParametersToSelect = preference.numberOfParametersToSelect
        nummberOfSelectedItemsLabel.text = "\(selectedParameters.count) of \(numberOfParametersToSelect) selected"
        self.navigationItem.title = preference.name.rawValue
    }
    
    
    // Initialisation of the view
    func configureView() {
        nextButton.isEnabled = false
        self.navigationItem.hidesBackButton = true
        self.tableView.tintColor = .blue
        activityIndicator.startAnimating()
    }
         
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }

    // MARK: - TableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            // Managed the checkmarks
            if cell.accessoryType == .none {
                if selectedParameters.count < numberOfParametersToSelect {
                    cell.accessoryType = .checkmark
                    selectedParameters.append(indexPath.row)
                }
            } else {
                cell.accessoryType = .none
                let index = selectedParameters.firstIndex(of: indexPath.row)
                if let index = index {
                    selectedParameters.remove(at: index)
                }
            }
            nummberOfSelectedItemsLabel.text = "\(selectedParameters.count) of \(numberOfParametersToSelect) selected"
            if selectedParameters.count == numberOfParametersToSelect { // The correct number of parameters is selected
                nextButton.isEnabled = true
            } else {
                nextButton.isEnabled = false
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextParameterSegue" {
            if let vc = segue.destination as? SelectParametersController {
                switch preferences[parameterNumber].name {
                case .genre:
                    updateParameters(for: .genre)
                case .certification:
                    updateParameters(for: .certification)
                case .popularActors:
                    updateParameters(for: .popularActors)
                }
                
                if parameterNumber == preferences.count-1 { // No more parameter, back to the main view controller
                        dismiss(animated: true, completion: nil)
                }
                
                vc.parameterNumber = parameterNumber + 1
                vc.preferences = preferences
            }
        }
    }
    
    // MARK: - Helper Functions
    // Get a reference to the main giew controller
    func rootViewController() -> ViewController? {
        if let rootNavVC = UIApplication.shared.keyWindow!.rootViewController as? UINavigationController, let rootVC = rootNavVC.viewControllers.first as? ViewController {
            return rootVC
        } else {
            return nil
        }
        
    }
    
    // Get the items selectionned by the user
    func getItemsFromSelectedParameters() -> [Item] {
        var items = [Item]()
        for i in selectedParameters {
            items.append(dataSource.object(at: IndexPath(row: i, section: 0)))
        }
        return items
    }
    
    // update the final array of parameters i.e. the one which will be used to obatin the movie list
    func updateParameters(for parameterType: ParameterType) {
        if let rootVC = rootViewController() {
            switch parameterType {
            case .genre:
                rootVC.genres.append(contentsOf: (getItemsFromSelectedParameters() as! [Genre]))
            case .certification:
                rootVC.certifications.append(contentsOf: getItemsFromSelectedParameters() as! [Certification])
            case .popularActors:
                rootVC.popularActors.append(contentsOf: getItemsFromSelectedParameters() as! [Actor])
            }
        }
        
    }
}


//            client.searchPopularActors() { [weak self] result in
//                switch result {
//                case .success(let actors):
//                    self?.dataSource.appendData(actors)
//                    self?.updateTableView()
//                case .failure(let error):
//                    self?.displayAlert(forError: error)
//                }
//            }
