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
    
    private let viewModel: ProfileViewModeling
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var labelFollowing: UILabel = {
        let labelFollowing = UILabel()
        labelFollowing.translatesAutoresizingMaskIntoConstraints = false
        labelFollowing.text = "Assuntos que sigo"
        labelFollowing.textAlignment = .left
        labelFollowing.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return labelFollowing
    }()
    
    private lazy var buttonFollow: UIButton = {
        let buttonFollow = UIButton()
        buttonFollow.translatesAutoresizingMaskIntoConstraints = false
        buttonFollow.setTitle("Adicionar", for: .normal)
        buttonFollow.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        buttonFollow.setTitleColor(.systemBlue, for: .normal)
        buttonFollow.layer.cornerRadius = 8
        
        return buttonFollow
    }()
    
    init(viewModel: ProfileViewModeling = ProfileViewModel()) {
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
        loadSubjects()
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
        setDefaultImage()
        buildLayout()
    }
    
    func loadSubjects() {
        Task {
            try await viewModel.getSubjectList()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        viewModel.logout()
        let viewController = SignInViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
    }
    
    private func removeLogoutButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    private func setDefaultImage() {
        let name = viewModel.getUsername()
        labelName.text = name
        labelInitials.text = name.getLettersInitiais()
    }
    
    private func setupSubjectsTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.register(ProfileSubjectCell.self, forCellReuseIdentifier: ProfileSubjectCell.identifier)
    }
    
    func buildLayout() {
        view.addSubview(buttonFollow)
        view.addSubview(labelFollowing)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            
            
            labelFollowing.topAnchor.constraint(equalTo: viewUserSection.bottomAnchor, constant: 20),
            labelFollowing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            buttonFollow.leadingAnchor.constraint(equalTo: labelFollowing.trailingAnchor, constant: 30),
            buttonFollow.centerYAnchor.constraint(equalTo: labelFollowing.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: labelFollowing.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfSubjects()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSubjectCell.identifier, for: indexPath) as? ProfileSubjectCell else { return UITableViewCell() }
        
        cell.setup(subject: viewModel.getSubjectName(at: indexPath.row))
        return cell
    }
    
}
