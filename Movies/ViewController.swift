//
//  ViewController.swift
//  Movies
//
//  Created by Zeiad on 08/01/2025.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieRealseYear: UILabel!
    @IBOutlet weak var genreSegment: UISegmentedControl!
    var movie : Movie?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieTitle.text = movie?.title
        if movie?.image != nil{
            movieImage.image = UIImage(contentsOfFile: movie!.image!)
        }
        movieRating.text = "\(movie?.rating ?? 0.0)"
        movieRealseYear.text = "\(movie?.releaseYear ?? 0)"
        genreSegment.removeAllSegments()

        for i in 0..<(movie?.genre.count ?? 0) {
            genreSegment.insertSegment(withTitle: movie?.genre[i], at: i, animated: true)
        }
    }



}

