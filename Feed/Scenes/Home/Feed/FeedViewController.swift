//
//  FeedViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    private let db = Firestore.firestore()
    private var posts: [PostModel] = []
    private var users: [String] = []
    
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var refreshing: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        stractPosts()
        refreshPosts()
    }
    
    func refreshPosts() {
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando")
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
        let ordenedPosts: [PostModel]?
        db.collection("Posts").getDocuments { query, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                self.posts.removeAll()
                for document in query?.documents ?? []{
                    let dict = document.data()
                    let message = dict["message"] as? String ?? ""
                    let userId = dict["userId"] as? String ?? ""
                    let name = dict["name"] as? String ?? ""
                    let date = dict["date"] as? String ?? ""
                    let model = PostModel(message: message, userId: userId, name: name, date: date)
                    self.posts.append(model)
                }
                
            }
        }
        
    }
    private func stractUsernames(_ userId: String) {
            
        db.collection("users").document(userId).getDocument() { (document, err) in //Pegando name com ID do usuario
        if let err = err {
            print(err.localizedDescription)
            }else {
                let dict = document?.data() ?? [:]
                let name = dict["name"] as? String ?? ""
                self.users.append(name)
                print(self.users)
                
            }
            
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as? FeedTableViewCell {
                let post = posts[indexPath.row]
            cell.setup(name: post.name, date: post.date, post: post.message)

            return cell
        }else{
            return UITableViewCell()
        }
    }
}
