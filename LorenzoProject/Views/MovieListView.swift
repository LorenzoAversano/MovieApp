import SwiftUI

struct MovieListView: View {
    @ObservedObject var myMovieList: MovieList
    @State private var newMovieScreenIsPresented = false
    var toggleFavorite: (Movie) -> Void

    var popularMovies: [Movie] {
        return myMovieList.movies.filter { $0.rating > 4 }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Mes Films")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                        ScrollView(.horizontal) {
                            LazyHStack(alignment: .top, spacing: 16) {
                                if myMovieList.movies.isEmpty {
                                    Button(action: {
                                        newMovieScreenIsPresented = true
                                    }) {
                                        Text("Ajouter votre premier film")
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                } else {
                                    ForEach(myMovieList.movies.indices, id: \.self) { index in
                                        NavigationLink(
                                            destination: MovieDetailsView(movie: myMovieList.movies[index]),
                                            label: {
                                                MovieCell(movie: myMovieList.movies[index]) {
                                                    toggleFavorite(myMovieList.movies[index])
                                                }
                                            }
                                        )
                                        .frame(width: 150)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }
                    }

                    Spacer().frame(height: 20)

                    VStack(alignment: .leading) {
                        Text("En Tendance")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                        ScrollView(.horizontal) {
                            LazyHStack(alignment: .top, spacing: 16) {
                                ForEach(popularMovies.indices, id: \.self) { index in
                                    NavigationLink(
                                        destination: EditMovieView(movie: popularMovies[index]),
                                        label: {
                                            MovieCell(movie: popularMovies[index]) {
                                                toggleFavorite(popularMovies[index])
                                            }
                                        }
                                    )
                                    .frame(width: 150)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            
        }
        .sheet(isPresented: $newMovieScreenIsPresented) {
            NewMovieScreen(movies: $myMovieList.movies, movielist: myMovieList, isPresented: $newMovieScreenIsPresented) {
                newMovieScreenIsPresented = false
            }
        }
        .navigationBarItems(trailing:
            Button(action: {
                newMovieScreenIsPresented = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
            }
            .padding()
        )
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(myMovieList: MovieList(movies: Movie.previewMovieList), toggleFavorite: { _ in })
    }
}
