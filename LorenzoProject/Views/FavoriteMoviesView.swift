//
//  FavoriteMoviesView.swift
//  LorenzoProject
//
//  Created by Lorenzo on 22/11/2023.
//

import SwiftUI

struct FavoriteMoviesView: View {
    @ObservedObject var myMovieList: MovieList
    var toggleFavorite: (Movie) -> Void

    var body: some View {
        List {
            ForEach(myMovieList.movies.filter { $0.isFavorite }) { movie in
                NavigationLink(destination: MovieDetailsView(movie: movie)) {
                    MovieCell(movie: movie) {
                        toggleFavorite(movie)
                    }
                }
                Divider()
            }
        }
        .navigationTitle("Favoris")
    }
}
