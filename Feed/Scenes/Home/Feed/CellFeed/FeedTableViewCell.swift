import UIKit

protocol FeedTableViewCellDelegate: AnyObject {
    func feedCellDidTapLike(at index: Int)
    func feedCellDidTapComments(at index: Int)
    func feedCellDidAddComment(_ text: String, at index: Int)
}

final class FeedTableViewCell: UITableViewCell {

    static let identifier = "FeedTableViewCell"

    weak var delegate: FeedTableViewCellDelegate?
    private var index: Int = 0

    // MARK: - UI
    private let avatarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .systemGray5
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Curtir ❤️", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comentários 💬", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let commentsContainerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let commentsListStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Adicione um comentário..."
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .send
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Layout
    private func setup() {
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(commentsContainerStack)

        commentsContainerStack.addArrangedSubview(commentsListStack)
        commentsContainerStack.addArrangedSubview(commentTextField)

        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        commentTextField.addTarget(self, action: #selector(commentTextFieldDidReturn), for: .editingDidEndOnExit)

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            dateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            messageLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            likeButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 16),

            commentsContainerStack.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8),
            commentsContainerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentsContainerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentsContainerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configure
    func configure(with post: PostModel, comments: [Comment]?, expanded: Bool, index: Int) {
        self.index = index
        nameLabel.text = post.name
        dateLabel.text = post.formattedDate
        messageLabel.text = post.message

        commentsListStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if expanded, let comments = comments {

            if !comments.isEmpty {
                for comment in comments {
                    let label = UILabel()
                    label.numberOfLines = 0
                    let attributed = NSMutableAttributedString(
                        string: "\(comment.userName) ",
                        attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
                    )
                    attributed.append(NSAttributedString(string: "\n\(comment.message)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
                    label.attributedText = attributed
                    commentsListStack.addArrangedSubview(label)
                }
            }
            commentsListStack.isHidden = false
            commentTextField.isHidden = false
        } else {
            commentsListStack.isHidden = true
            commentTextField.isHidden = true
        }
    }

    // MARK: - Actions
    @objc private func didTapLike() {
        delegate?.feedCellDidTapLike(at: index)
    }

    @objc private func didTapComments() {
        delegate?.feedCellDidTapComments(at: index)
    }

    @objc private func commentTextFieldDidReturn() {
        guard let text = commentTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        delegate?.feedCellDidAddComment(text, at: index)
        commentTextField.text = ""
        commentTextField.resignFirstResponder()
    }
}
