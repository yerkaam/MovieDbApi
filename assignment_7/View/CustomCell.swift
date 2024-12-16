//
//  CustomCell.swift
//  assignment_7
//
//  Created by Yerdaulet Orynbay on 14.12.2024.
//
import UIKit
class CustomCell: UITableViewCell {
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()

    let savedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    var movieId: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(likeButton)
        contentView.addSubview(savedButton)
        
        NSLayoutConstraint.activate([
         
            likeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20),
            savedButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 15),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    func updateButtonStates() {
        guard let movieId = movieId else { return }
        let currentUsername = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "defaultUser"
        
        let likedMoviesKey = "\(currentUsername)_likedMovies"
        let savedMoviesKey = "\(currentUsername)_savedMovies"

        let likedMovies = UserDefaults.standard.array(forKey: likedMoviesKey) as? [Int] ?? []
        let savedMovies = UserDefaults.standard.array(forKey: savedMoviesKey) as? [Int] ?? []
        
        // Обновляем иконки кнопок в зависимости от состояния
        if likedMovies.contains(movieId) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }

        if savedMovies.contains(movieId) {
            savedButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            savedButton.setImage(UIImage(systemName: "bookmark"), for: .normal) 
        }
    }
}
