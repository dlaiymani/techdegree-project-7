//
//  MoviesListDataSource.swift
//  MovieNight
//
//  Created by davidlaiymani on 12/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit


// DataSource for the movies list tabelview
class MovieListDataSource: NSObject, UITableViewDataSource {
    var data: [Movie]
    let tableView: UITableView
    
    let pendingOperations = PendingOperation()
    var activityIndicator: UIActivityIndicatorView
    
    init(data: [Movie], tableView: UITableView, activityIndicator: UIActivityIndicatorView) {
        self.data = data
        self.tableView = tableView
        self.activityIndicator = activityIndicator
        super.init()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // A cell = 2 text labels for the name and the overview + 1 imageview for the poster.
    // The poster is downloaded by using operation queues
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        let movie = object(at: indexPath)
        
        cell.textLabel?.text = movie.name
        cell.detailTextLabel?.text = movie.overview
        cell.imageView?.image = movie.poster
        
        if movie.posterState == .placeholder {
            downloadPosterForMovie(movie, atIndexPath: indexPath)
        }
        
        return cell
    }
    
    
    // MARK: Helpers functions to update the datasource and download the poster
    func update(_ object: Movie, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
    func updateData(_ data: [Movie]) {
        self.data = data
        
    }
    
    func object(at indexPath: IndexPath) -> Movie {
        return data[indexPath.row]
    }
    
    func moviesList() -> [Movie] {
        return self.data
    }
    
    // Downloading the poster by using Operation Queues
    func downloadPosterForMovie(_ movie: Movie, atIndexPath indexPath: IndexPath) {
        
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = PosterDownloader(movie: movie)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                if self.pendingOperations.downloadsInProgress.count == 0 {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
        
    }
}
