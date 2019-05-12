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
    
    lazy var client: ImdbClient = {
        return ImdbClient(configuration: .default)
    }()
    
    lazy var dataSource: SelectParametersDataSource = {
        return SelectParametersDataSource(data: [])
    }()
    
    var selectedParameters = [Int]()
    var parameterNumber = 1
    
    var test = "param1"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        nextButton.isEnabled = false
        self.navigationItem.hidesBackButton = true

        if parameterNumber == 2 {
            client.searchCertifications() { [weak self] result in
                switch result {
                case .success(let certification):
                    self?.dataSource.updateData(certification)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
        
        client.searchGenres() { [weak self] result in
            switch result {
            case .success(let genres):
                self?.dataSource.updateData(genres)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
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
                if selectedParameters.count < 5 {
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
            nummberOfSelectedItemsLabel.text = "\(selectedParameters.count) of 5 selected"
            if selectedParameters.count == 5 {
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
                
                switch parameterNumber {
                case 1:
                    updateParameters(for: .genre)
                case 2:
                    updateParameters(for: .certification)
                    dismiss(animated: true, completion: nil)
                default:
                    break
                }
                vc.parameterNumber = parameterNumber + 1
                vc.test = "param2"
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
    
    func updateParameters(for parameterType: ParemeterType) {
        
        if let rootVC = rootViewController() {
            switch parameterType {
            case .genre:
                rootVC.genres.append(contentsOf: (getItemsFromSelectedParameters() as! [Genre]))
            case .certification:
                rootVC.certifications.append(contentsOf: getItemsFromSelectedParameters() as! [Certification])
            }
        }
        
        
    }
    

}
