import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var movie: Movie
    @State private var title: String = ""
    @State private var isEditMovieViewPresented = false
    @State private var isDeleteAlertPresented = false

    @ObservedObject var movieList: MovieList

    var body: some View {
        ScrollView {
            VStack {
                if let imageUrl = movie.imageUrl,
                    let url = URL(string: imageUrl),
                    let imageData = try? Data(contentsOf: url),
                    let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } else {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(height: 200)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Avis: \(String(movie.avis.prefix(40)))" + (movie.avis.count > 20 ? "..." : ""))
                            .foregroundColor(.secondary)
                        Text("Note: \(String(repeating: "⭐️", count: Int(movie.rating)))")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        Text("Synopsis: \(movie.description ?? "Loading...")")
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding()

                HStack{
                    Button(action: {
                        isEditMovieViewPresented = true
                    }) {
                        Text("Modifier")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                    .sheet(isPresented: $isEditMovieViewPresented) {
                        EditMovieView(movie: movie)
                    }
                    Button(action: {
                        isDeleteAlertPresented = true
                    }) {
                        Text("Supprimer")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding()
                    .alert(isPresented: $isDeleteAlertPresented) {
                        Alert(
                            title: Text("Confirmer la suppression"),
                            message: Text("Êtes-vous sûr de vouloir supprimer ce film?"),
                            primaryButton: .destructive(Text("Supprimer")) {
                                movieList.movies.removeAll(where: { $0.id == movie.id })
                                isDeleteAlertPresented = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            title = movie.title
            fetchApiDescription()
        }
    }
    private func fetchApiDescription() {
        MovieAPI.fetchMovieDetails(title: title) { description in
            DispatchQueue.main.async {
                self.movie.description = description
            }
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let previewMovieList = Movie.previewMovieList
        let movieList = MovieList(movies: previewMovieList)
        
        return MovieDetailsView(movie: previewMovieList[0], movieList: movieList)
    }
}
