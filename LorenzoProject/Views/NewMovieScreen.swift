//
//  NewMovieScreen.swift
//  LorenzoProject
//
//  Created by Lorenzo on 21/11/2023.
//

import SwiftUI

struct NewMovieScreen: View {
    @Binding var movies: [Movie]
    @ObservedObject var movielist: MovieList
    @State private var imageUrl: String = ""
    @State private var title: String = ""
    @State private var avis: String = ""
    @State private var rating = 0.0
    
    @State private var isFavorite: Bool = false
    @Binding var isPresented: Bool
    var onAddMovie: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray)
            }
            
            TextField("Image (URL)", text: $imageUrl)
            TextField("Titre", text: $title)
            TextField("Avis", text: $avis)
            
            HStack {
                ForEach(1..<6) { index in
                    Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            rating = Double(index)
                        }
                }
            }
            Toggle("Favori", isOn: $isFavorite)
                .toggleStyle(SwitchToggleStyle(tint: .yellow))
            
            Button("Ajouter") {
                let newMovie = Movie(title: title, avis: avis, rating: rating, imageUrl: imageUrl, isFavorite: isFavorite)
                movies.append(newMovie) 
                isPresented = false
                resetFields()
            }
        }
        .padding()
    }
    
    private func resetFields() {
        title = ""
        avis = ""
        rating = 0.0
        imageUrl = ""
        isFavorite = false
    }
    
}


#Preview {
    MovieListView(myMovieList: MovieList(movies: Movie.previewMovieList), toggleFavorite: { _ in })
}
