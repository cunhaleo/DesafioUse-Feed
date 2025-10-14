import UIKit

final class FeedViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel: FeedViewModeling
    private let activity = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: FeedViewModeling = FeedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        view.backgroundColor = .systemBackground
        setupRefreshControl()
        setupTableView()
        setupActivity()
        bindViewModel()
        loadFeed()
    }
    
    private func setupRefreshControl() {
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        viewModel.loadFeed() { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    private func setupActivity() {
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func bindViewModel() {
        // reload data when vm tells
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }

        viewModel.shouldShowProgress = { [weak self] show in
            DispatchQueue.main.async {
                if show {
                    self?.activity.startAnimating()
                } else {
                    self?.activity.stopAnimating()
                }
            }
        }
    }

    private func loadFeed() {
        // usa a API que existe no ViewModel
        viewModel.loadFeed(completion: nil)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as? FeedTableViewCell else {
            return UITableViewCell()
        }

        let post = viewModel.posts[indexPath.row]
        // safe unwrap postId
        if let postId = post.postId {
            let expanded = viewModel.isExpanded(postId: postId)
            let comments = viewModel.expandedComments(for: postId)
            cell.configure(with: post, comments: comments, expanded: expanded, index: indexPath.row)
        } else {
            // post sem id (fallback)
            cell.configure(with: post, comments: nil, expanded: false, index: indexPath.row)
        }

        cell.delegate = self
        return cell
    }
}

// MARK: - FeedTableViewCellDelegate
extension FeedViewController: FeedTableViewCellDelegate {

    func feedCellDidTapLike(at index: Int) {

        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FeedTableViewCell else { return }

        UIView.animate(withDuration: 0.12,
                       animations: { cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97) },
                       completion: { _ in
                           UIView.animate(withDuration: 0.12) { cell.transform = .identity }
                       })
    }

    func feedCellDidTapComments(at index: Int) {
        let post = viewModel.posts[index]
        guard let postId = post.postId else { return }
        if viewModel.isExpanded(postId: postId) {
            viewModel.clearComments(for: postId)
            self.reloadRow(at: index)
        } else {
            viewModel.fetchComments(for: postId) { [weak self] comments in
                self?.reloadRow(at: index)
            }
        }
    }
    
    private func reloadRow(at index: Int) {
        let ip = IndexPath(row: index, section: 0)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [ip], with: .automatic)
            UIView.animate(withDuration: 0.25) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }

    func feedCellDidAddComment(_ text: String, at index: Int) {
        let post = viewModel.posts[index]
        guard let postId = post.postId else { return }
        viewModel.addComment(text, to: postId)
        viewModel.fetchComments(for: postId) { [weak self] _ in
            DispatchQueue.main.async {
                let ip = IndexPath(row: index, section: 0)
                self?.tableView.reloadRows(at: [ip], with: .automatic)
            }
        }
    }
}
