//
//  MovieCell.swift
//  LorenzoProject
//
//  Created by Lorenzo on 21/11/2023.
//

import SwiftUI

struct MovieCell: View {
    
    @ObservedObject var movie: Movie
    
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
                Text("Avis: \(movie.avis)")
                Text("Note: \(String(repeating: "⭐️", count: Int(movie.rating)))")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    MovieCell(movie: Movie.previewMovieList[0])
}
