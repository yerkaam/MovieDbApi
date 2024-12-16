import UIKit

class ActorViewController: UIViewController {
    var actor: Cast?
    var actorDetails: Actors?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let actorImageView = UIImageView()
    private let nameLabel = UILabel()
    private let biographyLabel = UILabel()
    private let alsoKnownAsLabel = UILabel()
    private let birthdayLabel = UILabel()
    private let placeOfBirthLabel = UILabel()
    
    private let separatorLine1 = UIView()
    private let separatorLine2 = UIView()
    private let separatorLine3 = UIView()
    private let separatorLine4 = UIView()

    init(actor: Cast) {
        self.actor = actor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = actor?.name
        setupUI()
        loadActorData()
    }

    private func setupUI() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        actorImageView.contentMode = .scaleAspectFill
        actorImageView.layer.cornerRadius = 100
        actorImageView.clipsToBounds = true
        actorImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        alsoKnownAsLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        placeOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false

        separatorLine1.backgroundColor = .white
        separatorLine1.translatesAutoresizingMaskIntoConstraints = false
        separatorLine2.backgroundColor = .white
        separatorLine2.translatesAutoresizingMaskIntoConstraints = false
        separatorLine3.backgroundColor = .white
        separatorLine3.translatesAutoresizingMaskIntoConstraints = false
        separatorLine4.backgroundColor = .white
        separatorLine4.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        biographyLabel.font = UIFont.systemFont(ofSize: 16)
        biographyLabel.numberOfLines = 0
        biographyLabel.textColor = .white
        nameLabel.textColor = .white

        alsoKnownAsLabel.font = UIFont.systemFont(ofSize: 16)
        alsoKnownAsLabel.textColor = .white
        alsoKnownAsLabel.numberOfLines = 0
        birthdayLabel.font = UIFont.systemFont(ofSize: 16)
        birthdayLabel.textColor = .white
        birthdayLabel.numberOfLines = 0
        placeOfBirthLabel.font = UIFont.systemFont(ofSize: 16)
        placeOfBirthLabel.textColor = .white
        placeOfBirthLabel.numberOfLines = 0

        contentView.addSubview(actorImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(biographyLabel)
        contentView.addSubview(alsoKnownAsLabel)
        contentView.addSubview(birthdayLabel)
        contentView.addSubview(placeOfBirthLabel)
        
        contentView.addSubview(separatorLine1)
        contentView.addSubview(separatorLine2)
        contentView.addSubview(separatorLine3)
        contentView.addSubview(separatorLine4)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            actorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            actorImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            actorImageView.widthAnchor.constraint(equalToConstant: 200),
            actorImageView.heightAnchor.constraint(equalToConstant: 200),

            nameLabel.topAnchor.constraint(equalTo: actorImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            separatorLine1.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            separatorLine1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorLine1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorLine1.heightAnchor.constraint(equalToConstant: 1),

            biographyLabel.topAnchor.constraint(equalTo: separatorLine1.bottomAnchor, constant: 20),
            biographyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            biographyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            separatorLine2.topAnchor.constraint(equalTo: biographyLabel.bottomAnchor, constant: 20),
            separatorLine2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorLine2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorLine2.heightAnchor.constraint(equalToConstant: 1),

            alsoKnownAsLabel.topAnchor.constraint(equalTo: separatorLine2.bottomAnchor, constant: 20),
            alsoKnownAsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            alsoKnownAsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            separatorLine3.topAnchor.constraint(equalTo: alsoKnownAsLabel.bottomAnchor, constant: 20),
            separatorLine3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorLine3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorLine3.heightAnchor.constraint(equalToConstant: 1),

            birthdayLabel.topAnchor.constraint(equalTo: separatorLine3.bottomAnchor, constant: 20),
            birthdayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthdayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            separatorLine4.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 20),
            separatorLine4.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorLine4.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorLine4.heightAnchor.constraint(equalToConstant: 1),

            placeOfBirthLabel.topAnchor.constraint(equalTo: separatorLine4.bottomAnchor, constant: 20),
            placeOfBirthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            placeOfBirthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            placeOfBirthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func loadActorData() {
        guard let actor = actor else { return }

        NetworkingManager.shared.getActors(actorId: actor.id) { [weak self] actorDetails in
            DispatchQueue.main.async {
                guard let details = actorDetails else { return }
                self?.actorDetails = details
                self?.nameLabel.text = details.name
                self?.biographyLabel.text = details.biography
                self?.alsoKnownAsLabel.text = "Also Known As: " + details.alsoKnownAs.joined(separator: ", ")
                self?.birthdayLabel.text = "Birthday: " + details.birthday
                self?.placeOfBirthLabel.text = "Place of Birth: " + details.placeOfBirth

                if !details.profilePath.isEmpty {
                    NetworkingManager.shared.loadImage(porterPath: details.profilePath) { image in
                        self?.actorImageView.image = image
                    }
                }
            }
        }
    }
}
