import Foundation
import UIKit

class MainVC: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    private let viewModel = MainViewModel()
    private var dataSource: [MovieDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
        viewModel.delegate = self
        viewModel.searchDelegate = self
    }
    
    private func setupView() {
        loadingIndicator.hidesWhenStopped = true
        title = "Moviepedia"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: MovieCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MovieCell.cellIdentifier)
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search movie"
        searchBar.showsCancelButton = true
    }
    
    private func performSearch(with query: String) {
        guard !query.isEmpty else {
            showAlert(message: "Please enter the movie to search")
            return
        }
        
        dataSource.removeAll()
        tableView.reloadData()
        
        viewModel.getMovies(with: query)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Moviepedia", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        present(alert, animated: true)
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.cellIdentifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        
        let item = dataSource[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailedVC") as? DetailedVC else { return }
        
        detailVC.movie = dataSource[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text else { return }
        performSearch(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }
}

extension MainVC: ViewModelDelegate {
    func didStartLoading() {
        loadingIndicator.startAnimating()
    }
    
    func didFinishLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func didReceiveError(_ error: String) {
        showAlert(message: error)
    }
}

extension MainVC: MainViewModelDelegate {
    func didReceiveMovies(_ data: [MovieDTO]) {
        dataSource = data
        tableView.reloadData()
    }
}
