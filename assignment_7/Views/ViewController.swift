import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private lazy var popularMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private lazy var upcomingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nowPlayingLabel: UILabel = {
        let label = UILabel()
        label.text = "Now Playing"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let upcomingLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var movies: [Movie] = []
    private var popularMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    
    let allButtonfornowplay: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let allButtonforpopular: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let allButtonforupcoming: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "Movies"
        layoutUI()
        if let username = UserDefaults.standard.string(forKey: "loggedInUsername") {
                    userLabel.text = "Welcome,to our App \(username)!"
                }
        
        getMovies { movies in
            self.movies = movies
            self.movieCollectionView.reloadData()
        }
        
        getPopularMovies { movies in
            self.popularMovies = movies
            self.popularMoviesCollectionView.reloadData()
        }
        
        getUpcomingMovies { movies in
            self.upcomingMovies = movies
            self.upcomingCollectionView.reloadData()
        }
    }
    
    private func layoutUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 1100
        view.addSubview(scrollView)
        
        scrollView.addSubview(userLabel)
        scrollView.addSubview(nowPlayingLabel)
        scrollView.addSubview(movieCollectionView)
        scrollView.addSubview(popularLabel)
        scrollView.addSubview(popularMoviesCollectionView)
        scrollView.addSubview(allButtonfornowplay)
        scrollView.addSubview(allButtonforpopular)
        scrollView.addSubview(upcomingCollectionView)
        scrollView.addSubview(upcomingLabel)
        scrollView.addSubview(allButtonforupcoming)

        NSLayoutConstraint.activate([
 
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            

            userLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            

            nowPlayingLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 15),
            nowPlayingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            

            movieCollectionView.topAnchor.constraint(equalTo: nowPlayingLabel.bottomAnchor),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCollectionView.heightAnchor.constraint(equalToConstant: 320),
            
          
            popularLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            popularLabel.topAnchor.constraint(equalTo: movieCollectionView.bottomAnchor, constant: 10),
            
            popularMoviesCollectionView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor),
            popularMoviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popularMoviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popularMoviesCollectionView.heightAnchor.constraint(equalToConstant: 320),
           
            upcomingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            upcomingLabel.topAnchor.constraint(equalTo: popularMoviesCollectionView.bottomAnchor, constant: 10),
            upcomingCollectionView.topAnchor.constraint(equalTo: upcomingLabel.bottomAnchor),
            upcomingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upcomingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upcomingCollectionView.heightAnchor.constraint(equalToConstant: 320),
            
            allButtonfornowplay.centerYAnchor.constraint(equalTo: nowPlayingLabel.centerYAnchor),
            allButtonfornowplay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            allButtonforupcoming.centerYAnchor.constraint(equalTo: upcomingLabel.centerYAnchor),
            allButtonforupcoming.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            allButtonforpopular.centerYAnchor.constraint(equalTo: popularLabel.centerYAnchor),
            allButtonforpopular.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        allButtonfornowplay.addTarget(self, action: #selector(allButtonTapped(_:)), for: .touchUpInside)
                allButtonforpopular.addTarget(self, action: #selector(allButtonTapped(_:)), for: .touchUpInside)
        allButtonforupcoming.addTarget(self, action: #selector(allButtonTapped(_:)), for: .touchUpInside)
    }
   
    @objc func allButtonTapped(_ sender: UIButton) {
        let moviesVC = MoviesViewController()

        if sender == allButtonfornowplay {
            moviesVC.titleText = "Now Playing"
            getMovies { movies in
                moviesVC.movies = movies
                self.navigationController?.pushViewController(moviesVC, animated: true)
            }
        } else if sender == allButtonforpopular {
            moviesVC.titleText = "Popular"
            getPopularMovies { movies in
                moviesVC.movies = movies
                self.navigationController?.pushViewController(moviesVC, animated: true)
            }
        } else if sender == allButtonforupcoming {
            moviesVC.titleText = "Upcoming"
            getUpcomingMovies { movies in
                moviesVC.movies = movies
                self.navigationController?.pushViewController(moviesVC, animated: true)
            }
           
        }
        else{
            
        }
    }

    
    private func getMovies(completion: @escaping ([Movie]) -> Void) {
        NetworkingManager.shared.getMovies { movies in
            DispatchQueue.main.async {
                self.movies = movies
                completion(movies)
            }
        }
    }
    private func getPopularMovies(completion: @escaping ([Movie]) -> Void) {
        NetworkingManager.shared.getPopularMovies { movies in
            DispatchQueue.main.async {
                self.popularMovies = movies
                completion(movies)
            }
        }
    }
    
    private func getUpcomingMovies(completion: @escaping ([Movie]) -> Void) {
        NetworkingManager.shared.getUpcomingMovies { movies in
            DispatchQueue.main.async {
                self.upcomingMovies = movies
                completion(movies) 
            }
        }
    }
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieCollectionView {
            return movies.count
        } else if collectionView == popularMoviesCollectionView {
            return popularMovies.count
        } else if collectionView == upcomingCollectionView {
            return upcomingMovies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        
        let movie: Movie
        if collectionView == movieCollectionView {
            movie = movies[indexPath.item]
        } else if collectionView == popularMoviesCollectionView {
            movie = popularMovies[indexPath.item]
        } else {
            movie = upcomingMovies[indexPath.item]
        }
        
        cell.titleLabel.text = movie.title
        NetworkingManager.shared.loadImage(porterPath: movie.posterPath) { image in
            DispatchQueue.main.async {
                cell.movieImageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie: Movie
        if collectionView == movieCollectionView {
            selectedMovie = movies[indexPath.item]
        } else if collectionView == popularMoviesCollectionView {
            selectedMovie = popularMovies[indexPath.item]
        } else {
            selectedMovie = upcomingMovies[indexPath.item]
        }
        
        let movieDetailViewController = MovieDetailViewController(movieId: selectedMovie.id)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    

}
