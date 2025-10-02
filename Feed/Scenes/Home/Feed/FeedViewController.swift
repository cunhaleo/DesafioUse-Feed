//
//  FeedViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit
import FirebaseFirestore

final class FeedViewController: UIViewController {
    
    private let db = Firestore.firestore()
    @Published private var posts: [PostModel] = []
    private var users: [String] = []
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        stractPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Feed"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        stractPosts()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.reloadData()
    }
    
    private func stractPosts() {
        var ordenedPosts: [PostModel] = []
        Task {
            do {
                ordenedPosts.removeAll()
                let postCollection = try await db.collection("Posts").getDocuments()
                
                for document in postCollection.documents {
                    let post = try document.data(as: PostModel.self)
                    ordenedPosts.append(post)
                }
                ordenedPosts.sort(by: {$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})
                posts = ordenedPosts
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            catch {
                refreshControl.endRefreshing()
                print("===> ERROR: \(error.localizedDescription)") // TODO: ADD ERROR HANDLER
            }
        }
    }
    
    private func stractComments(from postId: String) async -> [Comment] {
        var comments: [Comment] = []
        do {
            let documents = try await db.collection("Posts").document(postId).collection("comments").order(by: "date", descending: false).getDocuments()
            documents.documents.forEach { snapshot in
                let comment = try? snapshot.data(as: Comment.self)
                if let comment = comment {
                    comments.append(comment)
                }
            }
        } catch {
            // TODO: ERROR HANDLING
        }
        print("===> COMENTS: \(comments)")
        return comments
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as? FeedTableViewCell {
            let post = posts[indexPath.row]
            cell.setup(name: post.name, date: post.formattedDate, post: post.message)
            cell.didTapComments = { [weak self] in
                Task {
                    let comments = await self?.stractComments(from: post.postId ?? "")
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
