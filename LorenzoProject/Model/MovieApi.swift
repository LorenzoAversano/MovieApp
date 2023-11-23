//
//  MovieApi.swift
//  LorenzoProject
//
//  Created by Lorenzo on 23/11/2023.
//

import Foundation

extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url!
    }
}

class MovieAPI {
    static func fetchMovieDetails(title: String, completion: @escaping (String?) -> Void) {
        guard let apiKey = "38601cf9639a20ff1f34866ec9cbe8ee" as? String else {
            print("Clé API manquante")
            completion(nil) // Appel du bloc de complétion avec nil en cas d'erreur
            return
        }
        
        let apiUrl = "https://api.themoviedb.org/3/search/movie"
        let parameters: [String: String] = [
            "api_key": apiKey,
            "query": title
        ]
        
        guard let url = URL(string: apiUrl)?.appendingQueryParameters(parameters) else {
            print("URL invalide")
            completion(nil) // Appel du bloc de complétion avec nil en cas d'erreur
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Erreur lors de la récupération des données: \(error?.localizedDescription ?? "Inconnue")")
                completion(nil) // Appel du bloc de complétion avec nil en cas d'erreur
                return
            }
            
            do {
                let movieSearchResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                
                if let movie = movieSearchResponse.results.first {
                    DispatchQueue.main.async {
                        completion(movie.overview) // Appel du bloc de complétion avec la description du film
                    }
                } else {
                    print("Aucun résultat trouvé pour le film \(title)")
                    completion(nil) // Appel du bloc de complétion avec nil en cas d'absence de résultats
                }
            } catch let error {
                print("Erreur lors du décodage des données: \(error.localizedDescription)")
                completion(nil) // Appel du bloc de complétion avec nil en cas d'erreur de décodage
            }
        }.resume()
    }
}
