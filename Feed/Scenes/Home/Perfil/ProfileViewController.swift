//
//  HomeViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

final class ProfileViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var labelInitials: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewInitials: UIView!
    @IBOutlet weak var viewUserSection: UIView!
    
    private let userSession: UserSessionProtocol
    private let authManager: AuthManaging
    
    private let viewModel: ProfileViewModeling
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(userSession:UserSessionProtocol = UserSession.shared, authManager: AuthManaging = FirebaseAuthManager.shared, viewModel: ProfileViewModeling = ProfileViewModel()) {
        self.userSession = userSession
        self.authManager = authManager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubjectsTableView()
        setupUI()
        setupLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Perfil"
        setupLogoutButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeLogoutButton()
    }
    
    //MARK: - Methods
    
    func setupUI() {
        view.backgroundColor = AssetsManager.colorDarkerBackground
        viewUserSection.layer.cornerRadius = 16
        viewUserSection.backgroundColor = AssetsManager.colorBackground
        viewInitials.layer.cornerRadius = 60
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIBarButtonItem(
            title: "Sair",
            style: .plain,
            target: self,
            action: #selector(logout)
        )
        self.tabBarController?.navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func logout() {
        authManager.logout()
        let viewController = SignInViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
    }
    
    private func removeLogoutButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    private func setDefaultImage() {
        let name = userSession.name
        labelName.text = name
        labelInitials.text = name?.getLettersInitiais()
    }
    
    private func setupSubjectsTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        
        let labelFollowing = followingLabel()
        view.addSubview(labelFollowing)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            labelFollowing.topAnchor.constraint(equalTo: viewUserSection.bottomAnchor, constant: 20),
            labelFollowing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: labelFollowing.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    private func followingLabel() -> UILabel {
        let labelFollowing = UILabel()
        labelFollowing.translatesAutoresizingMaskIntoConstraints = false
        labelFollowing.text = "Seguindo"
        labelFollowing.textAlignment = .left
        labelFollowing.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return labelFollowing
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
}
