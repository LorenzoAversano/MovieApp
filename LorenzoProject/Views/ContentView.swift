import SwiftUI

struct ContentView: View {
    @StateObject var myMovieList: MovieList = MovieList(movies: Movie.previewMovieList)

    var body: some View {
        TabView {
            NavigationView {
                Text("MovieApp")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

            }
            .tabItem {
                Image(systemName: "house")
                Text("Accueil")
            }

            NavigationView {
                MovieListView(myMovieList: myMovieList, toggleFavorite: toggleFavorite)
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Tous les Films")
            }

            NavigationView {
                FavoriteMoviesView(myMovieList: myMovieList, toggleFavorite: toggleFavorite)
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favoris")
            }
        }
    }
    private func toggleFavorite(for movie: Movie) {
        if let index = myMovieList.movies.firstIndex(where: { $0.id == movie.id }) {
               myMovieList.movies[index].isFavorite.toggle()
        }
    }
}

#Preview {
    ContentView(myMovieList: MovieList(movies: Movie.previewMovieList))
}
