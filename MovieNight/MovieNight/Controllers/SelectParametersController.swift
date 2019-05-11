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
    
    var selectedParameters = [Genre]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        nextButton.isEnabled = false

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
                    selectedParameters.append(dataSource.object(at: indexPath))
                }
            } else {
                cell.accessoryType = .none
                let item = dataSource.object(at: indexPath)
                let index = selectedParameters.firstIndex(of: item)
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



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
