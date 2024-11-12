

import UIKit

class ActorCell: UITableViewCell {

    let actorNameLabel = UILabel()
    let actorImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        actorImageView.contentMode = .scaleAspectFill
        actorImageView.clipsToBounds = true
        actorImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actorImageView)
        
        actorNameLabel.numberOfLines = 0
        actorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actorNameLabel)
        
        NSLayoutConstraint.activate([
            actorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            actorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actorImageView.widthAnchor.constraint(equalToConstant: 60),
            actorImageView.heightAnchor.constraint(equalToConstant: 60),
            
            actorNameLabel.leadingAnchor.constraint(equalTo: actorImageView.trailingAnchor, constant: 10),
            actorNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with actor: Cast) {
        actorNameLabel.text = actor.name
        
        // Load actor's image
        if let profilePath = actor.profilePath {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(profilePath)"
            NetworkingManager.shared.loadImage(porterPath: imageUrl) { image in
                self.actorImageView.image = image
            }
        } else {
            actorImageView.image = UIImage(named: "defaultProfileImage")
        }
    }
}
