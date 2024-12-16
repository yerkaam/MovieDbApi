import Foundation
import UIKit

class NetworkingManager {
    static let shared = NetworkingManager()
    
    private let apiKey = "1b815b28ec5a6a3f1bd8bf5f314fe8a5"
    private let imageUrl = "https://image.tmdb.org/t/p/w500"
    private let baseUrl = "https://api.themoviedb.org/3"
    
    private let session = URLSession(configuration: .default)
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return components
    }()
    
    init() {}
}

extension NetworkingManager {
    func getMovies(from endpoint: String, completion: @escaping ([Movie]) -> Void) {
        urlComponents.path = endpoint
        guard let url = urlComponents.url else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let movieResponse = try JSONDecoder().decode(Movies.self, from: data)
                    DispatchQueue.main.async {
                        completion(movieResponse.results)
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            } else {
                print("Error: Invalid response or non-200 status code.")
            }
        }
        task.resume()
    }
    func getPopularMovies(completion: @escaping ([Movie]) -> Void) {
        getMovies(from: "/3/movie/top_rated", completion: completion)
    }

    func getMovies(completion: @escaping ([Movie]) -> Void) {
        getMovies(from: "/3/movie/now_playing", completion: completion)
    }

    func getUpcomingMovies(completion: @escaping ([Movie]) -> Void) {
        getMovies(from: "/3/movie/upcoming", completion: completion)
    }
    
    func loadImage(porterPath: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: imageUrl + porterPath) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let task = self.session.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Image loading error: \(error.localizedDescription)")
                    completion(nil)
                } else if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
    }
}

extension NetworkingManager {
    func getMovieDetails(movieId: Int, completion: @escaping (MovieDetail?) -> Void) {
        let url = "\(baseUrl)/movie/\(movieId)"
        guard let url = URL(string: url + "?api_key=\(apiKey)") else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(nil)
                return
            }
            
           
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                    DispatchQueue.main.async {
                        completion(movieDetail)
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                print("Error: Invalid response or non-200 status code.")
                completion(nil)
            }
        }
        task.resume()
    }
}

extension NetworkingManager {
    func getMovieCredits(movieId: Int, completion: @escaping ([Cast]) -> Void) {
        let url = "\(baseUrl)/movie/\(movieId)/credits"
        guard let url = URL(string: url + "?api_key=\(apiKey)") else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion([])
                return
            }
            
    
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let actorDetails = try JSONDecoder().decode(ActorDetails.self, from: data)
                    DispatchQueue.main.async {
                        completion(actorDetails.cast)
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion([])
                }
            } else {
                print("Error: Invalid response or non-200 status code.")
                completion([])
            }
        }
        task.resume()
    }
    func getMovieById(movieId: Int, completion: @escaping (MovieDetail?) -> Void) {
            let urlString = "\(baseUrl)/movie/\(movieId)"
            guard let url = URL(string: urlString + "?api_key=\(apiKey)") else { return }

            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    print(error?.localizedDescription ?? "No error description")
                    completion(nil)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let movie = try JSONDecoder().decode(MovieDetail.self, from: data)
                        DispatchQueue.main.async {
                            completion(movie)
                        }
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    print("Error: Invalid response or non-200 status code.")
                    completion(nil)
                }
            }
            task.resume()
        }
}
extension NetworkingManager {
    func getActors(actorId: Int, completion: @escaping (Actors?) -> Void) {
        let urlString = "\(baseUrl)/person/\(actorId)"
        guard let url = URL(string: urlString + "?api_key=\(apiKey)&language=en-US") else { return }

        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(nil)
                return
            }

           
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let actors = try JSONDecoder().decode(Actors.self, from: data)
                    DispatchQueue.main.async {
                        completion(actors)
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                print("Error: Invalid response or non-200 status code.")
                completion(nil)
            }
        }
        task.resume()
    }
}
