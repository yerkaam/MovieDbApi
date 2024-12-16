//
//  MoviesViewController.swift
//  assignment_7
//
//  Created by Yerdaulet Orynbay on 13.12.2024.
//
import UIKit

class MoviesViewController: UIViewController {
    
    var movies: [Movie] = []
    var titleText: String = ""
    
    private lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let numberOfItemsPerRow: CGFloat = 2
        let itemWidth = (view.frame.size.width - 32) / numberOfItemsPerRow
        let itemHeight: CGFloat = 300
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
           sectionLabel.text = titleText
          
        layoutUI()
        movieCollectionView.reloadData()
        
    }
    
    private func layoutUI() {
        view.addSubview(sectionLabel)
        view.addSubview(movieCollectionView)
        
        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            movieCollectionView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 20),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100), 
        
        ])
    }

}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.item]
        
        cell.titleLabel.text = movie.title
        NetworkingManager.shared.loadImage(porterPath: movie.posterPath) { image in
            DispatchQueue.main.async {
                cell.movieImageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        let movieDetailViewController = MovieDetailViewController(movieId: selectedMovie.id)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

