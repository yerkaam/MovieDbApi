//
//  UserViewController.swift
//  assignment_10
//
//  Created by Yerdaulet Orynbay on 15.12.2024.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let savedMoviesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Saved Movies"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likedMoviesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Liked Movies"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        return button
    }()
    
    var likedMoviesIds: [Int] = []
        var savedMoviesIds: [Int] = []
        
        var likedMovies: [MovieDetail] = []
        var savedMovies: [MovieDetail] = []
        
        var likedMoviesCollectionView: UICollectionView!
        var savedMoviesCollectionView: UICollectionView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
            setupUI()
            setupCollectionViews()
            displayUserData()
            loadProfileImage()
            
        }
        
        private func setupUI() {
           
            view.addSubview(profileImageView)
                   view.addSubview(usernameLabel)
                   view.addSubview(changePhotoButton)
                   view.addSubview(logoutButton)
                   view.addSubview(savedMoviesLabel)
                   view.addSubview(likedMoviesLabel)
                   
                   NSLayoutConstraint.activate([
                       
                       profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                       profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                       profileImageView.widthAnchor.constraint(equalToConstant: 150),
                       profileImageView.heightAnchor.constraint(equalToConstant: 150),
                       
                       usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                       usernameLabel.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor),
                       usernameLabel.widthAnchor.constraint(equalToConstant: 250),
                       
                       changePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                       changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
                       
                       logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                       logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                   ])
        }

        private func setupCollectionViews() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 100, height: 150)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            
            likedMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            savedMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
            likedMoviesCollectionView.delegate = self
            likedMoviesCollectionView.dataSource = self
            savedMoviesCollectionView.delegate = self
            savedMoviesCollectionView.dataSource = self
            likedMoviesCollectionView.backgroundColor = .black
            savedMoviesCollectionView.backgroundColor = .black
            
            likedMoviesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "LikedMovieCell")
            savedMoviesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SavedMovieCell")
            
            view.addSubview(likedMoviesCollectionView)
            view.addSubview(savedMoviesCollectionView)
            
            likedMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
            savedMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                savedMoviesLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
                savedMoviesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                
                likedMoviesLabel.topAnchor.constraint(equalTo: savedMoviesCollectionView.bottomAnchor, constant: 10),
                likedMoviesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                likedMoviesCollectionView.topAnchor.constraint(equalTo: likedMoviesLabel.bottomAnchor, constant: 10),
                likedMoviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                likedMoviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                likedMoviesCollectionView.heightAnchor.constraint(equalToConstant: 150),
                
                savedMoviesCollectionView.topAnchor.constraint(equalTo: savedMoviesLabel.bottomAnchor, constant: 10),
                savedMoviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                savedMoviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                savedMoviesCollectionView.heightAnchor.constraint(equalToConstant: 150)
            ])
            
        }
    @objc private func logoutTapped() {
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                let loginVC = SignUpViewController()
                let navigationController = UINavigationController(rootViewController: loginVC)
                sceneDelegate.setRootViewController(navigationController)
            }
        }
        
    @objc private func changePhotoTapped() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true

            present(imagePicker, animated: true, completion: nil)
        }

        private func saveProfileImage(image: UIImage) {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let currentUsername = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "defaultUser"
                UserDefaults.standard.set(imageData, forKey: "\(currentUsername)_profilePhoto")
            }
        }

        private func loadProfileImage() {
            let currentUsername = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "defaultUser"
            if let imageData = UserDefaults.standard.data(forKey: "\(currentUsername)_profilePhoto") {
                profileImageView.image = UIImage(data: imageData)
            } else {
                profileImageView.image = UIImage(systemName: "person.circle")
                profileImageView.tintColor = .lightGray
            }
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                profileImageView.image = selectedImage
                saveProfileImage(image: selectedImage)
            }
            dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }

    func displayUserData() {
        if let username = UserDefaults.standard.string(forKey: "loggedInUsername") {
            usernameLabel.text = "\(username)"
        } else {
            usernameLabel.text = "No user logged in"
        }
        let currentUsername = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "defaultUser"
      
        let likedMoviesKey = "\(currentUsername)_likedMovies"
        let savedMoviesKey = "\(currentUsername)_savedMovies"

        let likedMoviesIds = UserDefaults.standard.array(forKey: likedMoviesKey) as? [Int] ?? []
        let savedMoviesIds = UserDefaults.standard.array(forKey: savedMoviesKey) as? [Int] ?? []
        
        loadMoviesDetails(for: likedMoviesIds) { movies in
            self.likedMovies = movies
            self.likedMoviesCollectionView.reloadData()
        }
        
        loadMoviesDetails(for: savedMoviesIds) { movies in
            self.savedMovies = movies
            self.savedMoviesCollectionView.reloadData()
        }
    }


    func loadMoviesDetails(for movieIds: [Int], completion: @escaping ([MovieDetail]) -> Void) {
        guard !movieIds.isEmpty else {
            completion([])
            return
        }

        var movies: [MovieDetail] = []
        let group = DispatchGroup()

        for movieId in movieIds {
            group.enter()
            NetworkingManager.shared.getMovieById(movieId: movieId) { movie in
                if let movie = movie {
                    movies.append(movie)
                } else {
                    print("Failed to load movie with ID: \(movieId)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(movies)
        }
    }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == likedMoviesCollectionView {
                return likedMovies.count
            } else {
                return savedMovies.count
            }
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = collectionView == likedMoviesCollectionView ? "LikedMovieCell" : "SavedMovieCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? UICollectionViewCell else {
            fatalError("Failed to dequeue cell with identifier \(reuseIdentifier)")
        }

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let movie = collectionView == likedMoviesCollectionView ? likedMovies[indexPath.row] : savedMovies[indexPath.row]

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = cell.contentView.bounds
        imageView.backgroundColor = .darkGray
        cell.contentView.addSubview(imageView)

        NetworkingManager.shared.loadImage(porterPath: movie.posterPath) { [weak collectionView, weak cell] image in
            DispatchQueue.main.async {
              
                guard let collectionView = collectionView,
                      let cell = cell,
                      let index = collectionView.indexPath(for: cell),
                      index == indexPath else { return }

                imageView.image = image
            }
        }

        return cell
    }


    }
