//
//  Movie.swift
//  Movies
//
//  Created by Zeiad on 08/01/2025.
//

import Foundation
class Movie{
    var id: Int?
    var title: String?
    var image: String?
    var rating: Double?
    var releaseYear: Int?
    var genre = [String]()
    init(id: Int?, title: String?, image: String?, rating: Double?, releaseYear: Int?, genre: [String]) {
        self.id = id
        self.title = title
        self.image = image
        self.rating = rating
        self.releaseYear = releaseYear
        self.genre = genre
    }
}
