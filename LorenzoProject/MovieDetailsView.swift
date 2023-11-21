//
//  MovieDetailsView.swift
//  LorenzoProject
//
//  Created by Lorenzo on 21/11/2023.
//


import SwiftUI

struct MovieDetailsView: View {
    
    @ObservedObject var movie: Movie
    
    var body: some View {
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Avis: \(String(movie.avis.prefix(40)))" + (movie.avis.count > 20 ? "..." : ""))
                    Text("Note: \(String(repeating: "⭐️", count: Int(movie.rating)))")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    MovieDetailsView(movie: Movie.previewMovieList[0])
}
