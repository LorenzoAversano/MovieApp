import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var movie: Movie
    @State private var title: String = ""
    @State private var isEditMovieViewPresented = false


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

#Preview {
    MovieDetailsView(movie: Movie.previewMovieList[0])
}
