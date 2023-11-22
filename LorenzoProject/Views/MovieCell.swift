import SwiftUI

struct MovieCell: View {
    @ObservedObject var movie: Movie
    var onToggleFavorite: () -> Void

    var body: some View {
        HStack {
            if let imageUrl = movie.imageUrl,
               let url = URL(string: imageUrl),
               let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 100, height: 155)
            } else {
                Rectangle()
                     .frame(width: 100, height: 155)
                     .foregroundColor(.gray)
             }

            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text("Avis: \(limitedAvis)")
                Text("Note: \(String(repeating: "⭐️", count: Int(movie.rating)))")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Button(action: {
                    toggleFavorite()
                }) {
                    Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                }
            }
        }
    }

    private var limitedAvis: String {
        let maxAvisLength = 20
        if movie.avis.count > maxAvisLength {
            return String(movie.avis.prefix(maxAvisLength)) + "..."
        } else {
            return movie.avis
        }
    }

    private func toggleFavorite() {
        movie.isFavorite.toggle()
        onToggleFavorite()
    }
}

#Preview {
    MovieCell(movie: Movie.previewMovieList[0], onToggleFavorite: {})
}
