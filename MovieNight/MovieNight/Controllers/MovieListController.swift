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
                let alertError = AlertError(error: error, on: self)
                alertError.displayAlert()
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailMovieSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let movie = dataSource.object(at: indexPath)
            let detailMovieController = segue.destination as! DetailMovieController
            detailMovieController.movie = movie
            
        }
        
    }
}
