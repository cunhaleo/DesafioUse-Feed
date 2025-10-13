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
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        v.backgroundColor = .systemGray5
        return v
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 15)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let likeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Curtir ❤️", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let commentButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Comentários 💬", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    // container stack that will contain comments list + input; when children hidden, it collapses
    private let commentsContainerStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let commentsListStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Adicione um comentário..."
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .send
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
    /// - Parameters:
    ///   - post: PostModel (do seu projeto)
    ///   - comments: comentários expandidos (se existirem) — pode ser nil
    ///   - expanded: se a célula deve estar expandida
    ///   - index: índice da célula na tabela (usado em callbacks)
    func configure(with post: PostModel, comments: [Comment]?, expanded: Bool, index: Int) {
        self.index = index
        nameLabel.text = post.name
        dateLabel.text = post.formattedDate
        messageLabel.text = post.message

        // Reset comments area
        commentsListStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if expanded, let comments = comments, !comments.isEmpty {
            // mostrar os comentários
            for c in comments {
                let lbl = UILabel()
                lbl.numberOfLines = 0
                let attributed = NSMutableAttributedString(
                    string: "\(c.userName) ",
                    attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
                )
                attributed.append(NSAttributedString(string: "\n\(c.message)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
                lbl.attributedText = attributed
                commentsListStack.addArrangedSubview(lbl)
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
        // O viewModel não expõe método de like; apenas notifica a controller
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
