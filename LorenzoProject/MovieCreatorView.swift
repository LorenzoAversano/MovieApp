//
//  MovieCreatorView.swift
//  LorenzoProject
//
//  Created by Lorenzo on 20/11/2023.
//

import SwiftUI

struct MovieCreatorView: View {
    
    @Binding var movies: [Movie]
    @State private var newMovieTitle = ""
    @State private var newMovieRating = 0.0
    @State private var newMovieReview = ""
    @State private var newMovieImageUrl = ""
    
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nouveau Film")) {
                    TextField("Nom du Film", text: $newMovieTitle)
                    Stepper(value: $newMovieRating, in: 0...10, step: 0.5) {
                        Text("Note: \(newMovieRating, specifier: "%.1f")")
                    }
                    TextField("Avis", text: $newMovieReview)
                    TextField("URL de l'image", text: $newMovieImageUrl)
                }

                Section {
                    Button(action: {
                        let newMovie = Movie(title: newMovieTitle, rating: newMovieRating, review: newMovieReview, imageUrl: newMovieImageUrl)
                        self.movies.append(newMovie)
                        self.isPresented = false
                    }) {
                        Text("Ajouter Film")
                    }
                }
            }
            .navigationBarTitle("Créer un Film")
        }
    }
}
