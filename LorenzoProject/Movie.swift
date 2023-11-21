//
//  Movie.swift
//  LorenzoProject
//
//  Created by Lorenzo on 21/11/2023.
//

import Foundation
import SwiftUI

// Movie Model

class MovieList: ObservableObject {
    @Published var movies: [Movie]
    
    init(movies: [Movie]) {
        self.movies = movies
    }
}



class Movie: Identifiable, ObservableObject {
    let id: UUID = UUID()
    @Published var title: String
    @Published var avis: String
    @Published var rating: Double
    @Published var imageUrl: String?

    init(title: String, avis: String, rating: Double, imageUrl: String? = nil) {
        self.title = title
        self.avis = avis
        self.rating = rating
        self.imageUrl = imageUrl
    }
}

// Preview Data

extension Movie {
    static let previewMovieList: [Movie] = [
        Movie(title: "La La Land", avis: "Goat", rating: 5, imageUrl: "https://storage.googleapis.com/pod_public/1300/123744.jpg"),
        Movie(title: "Harry Potter 3", avis: "Incroyable", rating: 4.9, imageUrl: "https://m.media-amazon.com/images/I/71J22VUSXNL.jpg"),
        Movie(title: "Le Prestige", avis: "Gatesque", rating: 5, imageUrl: "https://fr.web.img6.acsta.net/medias/nmedia/18/62/84/94/18680369.jpg")
    ]
}
