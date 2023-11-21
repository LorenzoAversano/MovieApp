import SwiftUI

struct Movie: Identifiable {
    var id = UUID()
    var title: String
    var rating: Double
    var review: String
    var imageUrl: String?
}

struct ContentView: View {
    @State private var movies: [Movie] = []
    @State private var showingMovieCreator = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(movies) { movie in
                        MovieRow(movie: movie)
                    }
                }
            }
            .navigationBarTitle("Mes Films")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingMovieCreator = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingMovieCreator) {
                MovieCreatorView(movies: self.$movies, isPresented: self.$showingMovieCreator)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MovieRow: View {
    var movie: Movie

    var body: some View {
        HStack {
            if let imageUrl = movie.imageUrl,
               let url = URL(string: imageUrl),
               let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {

                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 50, height: 75)

            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 50, height: 75)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)

                HStack {
                    Text("Note: \(movie.rating, specifier: "%.1f")")
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("Avis: \(movie.review)")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

