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
    @State private var apiDescription: String?

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
                .onChange(of: title) { _ in
                    fetchApiDescription()
                }
            
            // Affichage de la description récupérée de l'API
            Text(apiDescription ?? "")
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)

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
                

                newMovie.description = apiDescription
                
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
        apiDescription = nil
    }

    private func fetchApiDescription() {
        guard let apiKey = "38601cf9639a20ff1f34866ec9cbe8ee" as? String else {
            print("Clé API manquante")
            return
        }

        let apiUrl = "https://api.themoviedb.org/3/search/movie"
        let parameters: [String: String] = [
            "api_key": apiKey,
            "query": title
        ]

        guard let url = URL(string: apiUrl)?.appendingQueryParameters(parameters) else {
            print("URL invalide")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Erreur lors de la récupération des données: \(error?.localizedDescription ?? "Inconnue")")
                return
            }

            do {
                let movieSearchResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)

                if let movie = movieSearchResponse.results.first {
                    DispatchQueue.main.async {
                        self.apiDescription = movie.overview
                    }
                } else {
                    print("Aucun résultat trouvé pour le film \(self.title)")
                }
            } catch let error {
                print("Erreur lors du décodage des données: \(error.localizedDescription)")
            }
        }.resume()
    }
}


#Preview {
    MovieListView(myMovieList: MovieList(movies: Movie.previewMovieList), toggleFavorite: { _ in })
}
