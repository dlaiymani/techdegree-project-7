//
//  MoviesListController.swift
//  MovieNight
//
//  Created by davidlaiymani on 12/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class MovieListController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var client: ImdbClient = {
        return ImdbClient(configuration: .default)
    }()
    
    
    lazy var dataSource: MovieListDataSource = {
        return MovieListDataSource(data: [], tableView: self.tableView, activityIndicator: self.activityIndicator)
    }()
    
    var genres = [Genre]()
    var certifications = [Certification]()
    var popularActors = [Actor]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Matching Movies"
        self.tableView.dataSource = dataSource

        activityIndicator.startAnimating()
        
        client.discoverMovies(genres: genres, certifications: certifications, popularActores: popularActors) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.dataSource.updateData(movies)
                self?.tableView.reloadData()
            case .failure(let error):
                if error == .jsonParsingFailure {
                    print("No Match")
                } else {
                    print(error)
                }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailMovieSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let movie = dataSource.object(at: indexPath)
            let detailMovieController = segue.destination as! DetailMovieController
            detailMovieController.movie = movie
            
        }
        
    }
    

}
