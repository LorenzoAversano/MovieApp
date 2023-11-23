import SwiftUI

struct MovieCell: View {
    @ObservedObject var movie: Movie
    var toggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = movie.imageUrl,
               let url = URL(string: imageUrl),
               let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(height: 200)
                    .cornerRadius(10)
            }

            Text(movie.title)
                .font(.headline)
                .padding(.top, 8)
                .padding(.leading, 8)
        }
    }
}


#Preview {
    MovieCell(movie: Movie.previewMovieList[0], toggleFavorite: {})
}
