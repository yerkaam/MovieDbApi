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

    init(actor: Cast) {
        self.actor = actor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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

        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        biographyLabel.font = UIFont.systemFont(ofSize: 16)
        biographyLabel.numberOfLines = 0
        biographyLabel.textColor = .gray

        alsoKnownAsLabel.font = UIFont.systemFont(ofSize: 16)
        birthdayLabel.font = UIFont.systemFont(ofSize: 16)
        placeOfBirthLabel.font = UIFont.systemFont(ofSize: 16)

        contentView.addSubview(actorImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(biographyLabel)
        contentView.addSubview(alsoKnownAsLabel)
        contentView.addSubview(birthdayLabel)
        contentView.addSubview(placeOfBirthLabel)

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

            biographyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            biographyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            biographyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            alsoKnownAsLabel.topAnchor.constraint(equalTo: biographyLabel.bottomAnchor, constant: 20),
            alsoKnownAsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            alsoKnownAsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            birthdayLabel.topAnchor.constraint(equalTo: alsoKnownAsLabel.bottomAnchor, constant: 20),
            birthdayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthdayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            placeOfBirthLabel.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 20),
            placeOfBirthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            placeOfBirthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            placeOfBirthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func loadActorData() {
        guard let actor = actor else { return }

     
        NetworkingManager.shared.getActors(actorId: actor.id) { actorDetails in
            DispatchQueue.main.async {
                guard let details = actorDetails else { return }

                self.actorDetails = details
                self.nameLabel.text = details.name
                self.biographyLabel.text = details.biography
                self.alsoKnownAsLabel.text = "Also Known As: " + details.alsoKnownAs.joined(separator: ", ")
                self.birthdayLabel.text = "Birthday: " + details.birthday
                self.placeOfBirthLabel.text = "Place of Birth: " + details.placeOfBirth

                if !details.profilePath.isEmpty {
                    NetworkingManager.shared.loadImage(porterPath: details.profilePath) { image in
                        self.actorImageView.image = image
                    }
                }

            }
        }
    }
}
