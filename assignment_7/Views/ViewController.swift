import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "MovieDB"
        layoutUI()
        getMovies()
    }
    
    private func layoutUI() {
        view.addSubview(movieTableView)
        NSLayoutConstraint.activate([
            movieTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func getMovies() {
        NetworkingManager.shared.getMovies { movies in
            self.movies = movies
            self.movieTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        
        NetworkingManager.shared.loadImage(porterPath: movie.posterPath) { image in
            cell.movieImageView.image = image
        }
        
        cell.voteAverageLabel.text = "Rating: \(movie.voteAverage)"
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        let movieDetailViewController = MovieDetailViewController(movieId: selectedMovie.id)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
