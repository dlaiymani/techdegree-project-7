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
    
    let queue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Matching Movies"
        self.tableView.dataSource = dataSource

        activityIndicator.startAnimating()
        

        let user1Download = MovieDownloader(genres: Array(genres.prefix(3)), certifications: Array(certifications.prefix(1)), actors: Array(popularActors.prefix(3)), client: client)
        let user2Download = MovieDownloader(genres: Array(genres.suffix(3)), certifications: Array(certifications.suffix(1)), actors: Array(popularActors.suffix(3)), client: client)
        user2Download.addDependency(user1Download)
        
        user2Download.completionBlock = {
            DispatchQueue.main.async {
                print(user1Download.movies)
                print(user2Download.movies)
                self.dataSource.updateData(self.preserveDuplicates(moviesUser1: user1Download.movies, moviesUser2: user2Download.movies))
                
                if self.dataSource.data.count == 0 {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    let alertError = AlertError(error: .jsonParsingFailure, on: self)
                    alertError.displayAlert()
                }
                self.tableView.reloadData()
            }
        }
        
        queue.addOperation(user1Download)
        queue.addOperation(user2Download)
        
    }
    
    
    func preserveDuplicates(moviesUser1: [Movie], moviesUser2: [Movie]) -> [Movie] {
        var result = [Movie]()
    
        for movie in moviesUser1{
            if moviesUser2.contains(movie) == true {
                result.append(movie)
            }
        }
        
        return result
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailMovieSegue" { // Display the detail of a movie
            let indexPath = self.tableView.indexPathForSelectedRow!
            let movie = dataSource.object(at: indexPath)
            let detailMovieController = segue.destination as! DetailMovieController
            detailMovieController.movie = movie
            
        }
        
    }
}
