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
                NavigationLink(destination: EditMovieView(movie: movie)) {
                    HStack {
                        Text(movie.title)
                        Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .onTapGesture {
                                if let index = myMovieList.movies.firstIndex(where: { $0.id == movie.id }) {
                                    myMovieList.movies[index].isFavorite.toggle()
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Favoris")
    }
}


