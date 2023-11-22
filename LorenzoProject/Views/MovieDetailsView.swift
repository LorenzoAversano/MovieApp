import SwiftUI

extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url!
    }
}

struct MovieDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var movie: Movie

    @State private var editedTitle: String
    @State private var editedAvis: String
    @State private var editedRating: Int
    @State private var editedImageUrl: String?
    @State private var isFavorite: Bool
    @State private var movieDescription: String?
    @State private var isDescriptionLoaded: Bool = false

    init(movie: Movie) {
        self.movie = movie
        _editedTitle = State(initialValue: movie.title)
        _editedAvis = State(initialValue: movie.avis)
        _editedRating = State(initialValue: Int(movie.rating))
        _editedImageUrl = State(initialValue: movie.imageUrl)
        _isFavorite = State(initialValue: movie.isFavorite)
    }

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: editedImageUrl ?? "")) { image in
                    image.resizable()
                        .clipShape(Rectangle())
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 250)

                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Titre")
                            .foregroundColor(.gray)

                        TextField("Titre", text: $editedTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: editedTitle) { newValue in
                                fetchMovieDescription()
                            }
                    }
                    VStack(alignment: .leading) {
                        Text("Avis")
                            .foregroundColor(.gray)

                        TextField("Avis", text: $editedAvis)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack(alignment: .leading) {
                        Text("Note")
                            .foregroundColor(.gray)
                        Stepper(value: $editedRating, in: 1...5) {
                            Text("Note: \(String(repeating: "⭐️", count: editedRating))")
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Description")
                            .foregroundColor(.gray)

                        if let movieDescription = movieDescription {
                            Text(movieDescription)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 10)
                        } else {
                            Text("Chargement de la description...")
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 10)
                        }
                    }
                    .padding(.top, 10)

                    HStack {
                        Text("Favori")
                            .foregroundColor(.gray)

                        Toggle("", isOn: $isFavorite)
                            .toggleStyle(SwitchToggleStyle(tint: .yellow))
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)

                Button(action: {
                    applyChanges()
                    fetchMovieDescription()
                    dismiss()
                }) {
                    Text("Modifier")
                }
                .padding()
            }
            .padding()
            .navigationTitle(movie.title)
            .onAppear {
                editedTitle = movie.title
                editedAvis = movie.avis
                editedRating = Int(movie.rating)
                editedImageUrl = movie.imageUrl
                isFavorite = movie.isFavorite
            }
        }
    }

    private func applyChanges() {
        movie.title = editedTitle
        movie.avis = editedAvis
        movie.rating = Double(editedRating)
        movie.imageUrl = editedImageUrl
        movie.isFavorite = isFavorite
    }
    
    

    private func fetchMovieDescription() {
        guard let apiKey = "38601cf9639a20ff1f34866ec9cbe8ee" as? String else {
            print("Clé API manquante")
            return
        }


        let movieTitle = editedTitle

        let apiUrl = "https://api.themoviedb.org/3/search/movie"
        let parameters: [String: String] = [
            "api_key": apiKey,
            "query": movieTitle
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
                        self.movieDescription = movie.overview
                        self.isDescriptionLoaded = true
                    }
                } else {
                    print("Aucun résultat trouvé pour le film \(movieTitle)")
                }
            } catch let error {
                print("Erreur lors du décodage des données: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie.previewMovieList[0])
    }
}
