import SwiftUI

struct MovieListView: View {
    @ObservedObject var myMovieList: MovieList
    @State private var newMovieScreenIsPresented = false
    var toggleFavorite: (Movie) -> Void
    

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 16) {
                    List {
                        ForEach(myMovieList.movies.indices, id: \.self) { index in
                            NavigationLink(destination: MovieDetailsView(movie: myMovieList.movies[index])) {
                                MovieCell(movie: myMovieList.movies[index]) {
                                    toggleFavorite(myMovieList.movies[index])
                                }
                            }
                            Divider()
                        }
                        .onDelete(perform: deleteMovie)
                    }
                    .padding(.horizontal, 1)
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
            NewMovieScreen(movies: $myMovieList.movies, movielist: myMovieList, isPresented: $newMovieScreenIsPresented) {
                newMovieScreenIsPresented = false
            }
        }


    }

    private func deleteMovie(at offsets: IndexSet) {
        myMovieList.movies.remove(atOffsets: offsets)
    }
}

#Preview {
    MovieListView(myMovieList: MovieList(movies: Movie.previewMovieList), toggleFavorite: { _ in })
}
