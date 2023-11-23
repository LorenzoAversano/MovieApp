import SwiftUI

struct EditMovieView: View {
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
                        Text("Image (URL)")
                            .foregroundColor(.gray)
                        
                        TextField("Image (URL)", text: Binding(
                            get: { editedImageUrl ?? "" },
                            set: { editedImageUrl = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    fetchMovieDescription()
                    applyChanges()
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
                fetchMovieDescription()
            }
        }
    }

    private func applyChanges() {
        movie.title = editedTitle
        movie.avis = editedAvis
        movie.rating = Double(editedRating)
        movie.imageUrl = editedImageUrl
        movie.isFavorite = isFavorite
        movie.description = movieDescription
        
    }

    private func fetchMovieDescription() {
        MovieAPI.fetchMovieDetails(title: editedTitle) { description in
            DispatchQueue.main.async {
                self.movieDescription = description
                self.isDescriptionLoaded = true
            }
        }
    }
}

struct EditMovieView_Previews: PreviewProvider {
    static var previews: some View {
        EditMovieView(movie: Movie.previewMovieList[0])
    }
}
