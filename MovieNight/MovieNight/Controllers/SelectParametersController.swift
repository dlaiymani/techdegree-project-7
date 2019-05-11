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
       // nextButton.isEnabled = false

        if test == "param2" {
            client.searchCertifications() { [weak self] result in
                switch result {
                case .success(let certification):
                    self?.dataSource.updateData(certification)
                    self?.tableView.reloadData()
                    //                self?.dataSource.update(with: businesses)
                    //                self?.tableView.reloadData()
                    //
                    //                self?.mapView.removeAnnotations(self!.mapView.annotations)
                //                self?.mapView.addAnnotations(businesses)
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
//                self?.dataSource.update(with: businesses)
//                self?.tableView.reloadData()
//
//                self?.mapView.removeAnnotations(self!.mapView.annotations)
//                self?.mapView.addAnnotations(businesses)
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
          //  cell.accessoryType = .none
        }
    }
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
                vc.test = "param2"
                
                if let rootNavVC = UIApplication.shared.keyWindow!.rootViewController as? UINavigationController, let rootVC = rootNavVC.viewControllers.first as? ViewController {
                    
                    if parameterNumber == 1 {
                        var genres = [Genre]()
                        for i in selectedParameters {
                            genres.append(dataSource.object(at: IndexPath(row: i, section: 0)) as! Genre)
                        }
                        rootVC.genres.append(contentsOf: genres)
                    }
                    
                    if parameterNumber == 2 {
                        var certifications = [Certification]()
                        for i in selectedParameters {
                            certifications.append(dataSource.object(at: IndexPath(row: i, section: 0)) as! Certification)
                        }
                        rootVC.certification.append(contentsOf: certifications)
                        dismiss(animated: true, completion: nil)
                        //self.navigationController?.popToViewController(rootVC, animated: true)
                    }
                }
                vc.parameterNumber = parameterNumber + 1
            }
        }
    }
    

}
