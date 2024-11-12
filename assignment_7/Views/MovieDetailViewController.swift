import UIKit

class MovieDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movieId: Int
    var movieDetail: MovieDetail?
    var cast: [Cast] = []
    
    let movieImageView = UIImageView()
    let tableView = UITableView()

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
        view.backgroundColor = .white

        movieImageView.contentMode = .scaleAspectFit
        movieImageView.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.register(ActorCell.self, forCellReuseIdentifier: "ActorCell")

        let headerView = UIView()
        headerView.addSubview(movieImageView)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadMovieDetails(for: movieId)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return movieDetail?.genres.count ?? 0
        case 3:
            return movieDetail?.spokenLanguages.count ?? 0
        case 4:
            return movieDetail?.productionCompanies.count ?? 0
        case 5:
            return cast.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        if indexPath.section == 5 {
            return 100
        }
        return UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 5 {
            return 15
        }
        return 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieDetail = movieDetail else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            cell.selectionStyle = .none
            cell.imageView?.image = movieImageView.image
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = movieDetail.overview
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            let genre = movieDetail.genres[indexPath.row]
            cell.textLabel?.text = genre.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            let language = movieDetail.spokenLanguages[indexPath.row]
            cell.textLabel?.text = language.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            let company = movieDetail.productionCompanies[indexPath.row]
            cell.textLabel?.text = company.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell

        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActorCell", for: indexPath) as! ActorCell
            let actor = cast[indexPath.row]
            cell.configure(with: actor)
            return cell

        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Overview"
        case 2:
            return "Genres"
        case 3:
            return "Languages"
        case 4:
            return "Production Companies"
        case 5:
            return "Actors"
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 5 { 
            let selectedActor = cast[indexPath.row]
            let actorDetailVC = ActorViewController(actor: selectedActor)
            navigationController?.pushViewController(actorDetailVC, animated: true)
        }
    }
}
