import UIKit

class MovieDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movieId: Int
    var movieDetail: MovieDetail?
    var cast: [Cast] = []
    
    let movieImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
    let tableView = UITableView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadMovieDetails(for movieId: Int) {
        NetworkingManager.shared.getMovieDetails(movieId: movieId) { [weak self] movieDetail in
            self?.movieDetail = movieDetail
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
  
        NetworkingManager.shared.getMovieCredits(movieId: movieId) { [weak self] cast in
            self?.cast = cast
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func updateUI() {
        guard let movieDetail = movieDetail else { return }
        title = movieDetail.title
    
        if !movieDetail.posterPath.isEmpty {
            NetworkingManager.shared.loadImage(porterPath: movieDetail.posterPath) { image in
                self.movieImageView.image = image
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = ""
        
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.register(ActorCell.self, forCellReuseIdentifier: "ActorCell")
                view.addSubview(movieImageView)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: -80),
                       movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                       movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 250),
                       
        ])
        
       
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadMovieDetails(for: movieId)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return movieDetail?.genres.count ?? 0
        case 4:
            return movieDetail?.spokenLanguages.count ?? 0
        case 5:
            return movieDetail?.productionCompanies.count ?? 0
        case 6:
            return cast.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 6 {
            return 110
        }
        return UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieDetail = movieDetail else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
               let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
               
               cell.movieId = movieDetail.id
            cell.backgroundColor = .black
               cell.updateButtonStates()
               cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
               cell.savedButton.addTarget(self, action: #selector(savedButtonTapped(_:)), for: .touchUpInside)
               
               return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            cell.backgroundColor = .black
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = movieDetail.title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.textLabel?.textColor = .white
            cell.textLabel?.textAlignment = .center
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = movieDetail.overview
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .black
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            let genre = movieDetail.genres[indexPath.row]
            cell.textLabel?.text = genre.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .black
          
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            let language = movieDetail.spokenLanguages[indexPath.row]
            cell.textLabel?.text = language.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .black
          
            return cell

        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            let company = movieDetail.productionCompanies[indexPath.row]
            cell.textLabel?.text = company.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .black
       
            return cell

        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActorCell", for: indexPath) as! ActorCell
            let actor = cast[indexPath.row]
            cell.backgroundColor = .black
            cell.configure(with: actor)
          
            return cell

        default:
            return UITableViewCell()
        }
    }
    @objc func likeButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? CustomCell else { return }
        guard let movieId = cell.movieId else { return }
        
        let currentUsername = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "defaultUser"
        let likedMoviesKey = "\(currentUsername)_likedMovies"
        
        var likedMovies = UserDefaults.standard.array(forKey: likedMoviesKey) as? [Int] ?? []
        
        if likedMovies.contains(movieId) {
            likedMovies.removeAll { $0 == movieId }
        } else {
            likedMovies.append(movieId)
        }
        
        UserDefaults.standard.set(likedMovies, forKey: likedMoviesKey)
        
        cell.updateButtonStates()
    }

    @objc func savedButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? CustomCell else { return }
        guard let movieId = cell.movieId else { return }
        
        let currentUsername = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "defaultUser"
        let savedMoviesKey = "\(currentUsername)_savedMovies"
        
        var savedMovies = UserDefaults.standard.array(forKey: savedMoviesKey) as? [Int] ?? []
        
        if savedMovies.contains(movieId) {
        
            savedMovies.removeAll { $0 == movieId }
        } else {
      
            savedMovies.append(movieId)
        }
        
        UserDefaults.standard.set(savedMovies, forKey: savedMoviesKey)
        
        cell.updateButtonStates()
    }



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        switch section {
        case 2:
            titleLabel.text = "Overview"
        case 3:
            titleLabel.text = "Genres"
        case 4:
            titleLabel.text = "Languages"
        case 5:
            titleLabel.text = "Production Companies"
        case 6:
            titleLabel.text = "Actors"
        default:
            titleLabel.text = ""
        }
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6 {
            let selectedActor = cast[indexPath.row]
            let actorDetailVC = ActorViewController(actor: selectedActor)
            navigationController?.pushViewController(actorDetailVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }
        return UITableView.automaticDimension  
    }

    }
