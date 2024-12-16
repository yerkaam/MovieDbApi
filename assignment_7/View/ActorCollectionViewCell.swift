//
//  ActorCollectionViewCell.swift
//  assignment_7
//
//  Created by Yerdaulet Orynbay on 14.12.2024.
//

import Foundation
import UIKit
class ActorCollectionViewCell: UICollectionViewCell {
    private let actorImageView = UIImageView()
    private let actorNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(actorImageView)
        contentView.addSubview(actorNameLabel)
        
        actorImageView.contentMode = .scaleAspectFill
        actorImageView.clipsToBounds = true
        
        actorNameLabel.textAlignment = .center
        
        actorImageView.translatesAutoresizingMaskIntoConstraints = false
        actorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            actorImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            actorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actorImageView.heightAnchor.constraint(equalToConstant: 100),
            
            actorNameLabel.topAnchor.constraint(equalTo: actorImageView.bottomAnchor, constant: 5),
            actorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with actor: Cast) {
        // Setup actor image and name
        actorNameLabel.text = actor.name
        // You should load the image here using the actor's image URL
    }
}
