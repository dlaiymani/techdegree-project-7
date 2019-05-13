//
//  SelectParametersController.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

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
    var preferences = [ParameterType]()
    var parameterNumber = 0
    var numberOfParametersToSelect = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        nextButton.isEnabled = false
        self.navigationItem.hidesBackButton = true
        self.tableView.tintColor = .blue
        activityIndicator.startAnimating()
        
        switch preferences[parameterNumber] {
        case .genre:
            numberOfParametersToSelect = 3
            self.navigationItem.title = ParameterType.genre.rawValue
            client.searchGenres() { [weak self] result in
                switch result {
                case .success(let genres):
                    self?.dataSource.updateData(genres)
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                case .failure(let error):
                    let alertError = AlertError(error: error, on: self)
                    alertError.displayAlert()
                }
            }
        case .certification:
            numberOfParametersToSelect = 1
            self.navigationItem.title = ParameterType.certification.rawValue
            client.searchCertifications() { [weak self] result in
                switch result {
                case .success(let certification):
                    self?.dataSource.updateData(certification)
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                case .failure(let error):
                    let alertError = AlertError(error: error, on: self)
                    alertError.displayAlert()

                }
            }
        case .popularActors:
            numberOfParametersToSelect = 3
            self.navigationItem.title = ParameterType.popularActors.rawValue
            client.searchPopularActors() { [weak self] result in
                switch result {
                case .success(let actors):
                    self?.dataSource.appendData(actors)
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                case .failure(let error):
                    let alertError = AlertError(error: error, on: self)
                    alertError.displayAlert()
                }
            }
            
        }
    }
         
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }

    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
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
            if selectedParameters.count == numberOfParametersToSelect {
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
                
                
                switch preferences[parameterNumber] {
                case .genre:
                    updateParameters(for: .genre)
                case .certification:
                    updateParameters(for: .certification)
                case .popularActors:
                    updateParameters(for: .popularActors)
                }
                
                if parameterNumber == preferences.count-1 {
                        dismiss(animated: true, completion: nil)
                }
                
                vc.parameterNumber = parameterNumber + 1
                vc.preferences = preferences
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func rootViewController() -> ViewController? {
        if let rootNavVC = UIApplication.shared.keyWindow!.rootViewController as? UINavigationController, let rootVC = rootNavVC.viewControllers.first as? ViewController {
            return rootVC
        } else {
            return nil
        }
        
    }
    
    func getItemsFromSelectedParameters() -> [Item] {
        var items = [Item]()
        for i in selectedParameters {
            items.append(dataSource.object(at: IndexPath(row: i, section: 0)))
            print(dataSource.object(at: IndexPath(row: i, section: 0)))
        }
        return items
    }
    
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
