import SwiftUI

struct ContentView: View {
    @State private var movies: [Movie] = []
    @State private var showingMovieCreator = false
    @State private var selectedMovie: Movie?
    @State var newMovieScreenIsPresented = false
    @StateObject var myMovieList: MovieList
    @State var selectedIndex: Int = -1

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading, spacing: 16) {
                        List{
                            ForEach(myMovieList.movies.indices, id: \.self) { index in
                                NavigationLink(destination: MovieDetailsView(movie: myMovieList.movies[index])) {
                                    MovieCell(movie: myMovieList.movies[index])
                                }
                                Divider()
                            }
                            .onDelete(perform: deleteMovie)
                        }
                    
                        .padding(.horizontal, 1) // Réduit la largeur
                }

                Button(action: {
                    newMovieScreenIsPresented = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Mes Films")
        }
        .sheet(isPresented: $newMovieScreenIsPresented) {
            NewMovieScreen(movielist: myMovieList, isPresented: $newMovieScreenIsPresented) {
                newMovieScreenIsPresented = false
            }
        }
    }

    private func deleteMovie(at offsets: IndexSet) {
        myMovieList.movies.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView(myMovieList: MovieList(movies: Movie.previewMovieList))
}
