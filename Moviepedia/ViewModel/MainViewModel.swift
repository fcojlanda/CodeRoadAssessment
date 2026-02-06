import Foundation

protocol MainViewModelDelegate: AnyObject {
    func didReceiveMovies(_ data: [MovieDTO])
}

final class MainViewModel {
    weak var delegate: ViewModelDelegate?
    weak var searchDelegate: MainViewModelDelegate?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func getMovies(with text: String) {
        delegate?.didStartLoading()
        
        guard let endpoint = URL(string: "http://www.omdbapi.com/?apikey=7be98d2c&s=\(text)") else {
            delegate?.didReceiveError("Invalid URL")
            return
        }
        
        networkService.request(url: endpoint) { [weak self] (result: Result<SearchResponse, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.didFinishLoading()
                
                switch result {
                case .success(let data):
                    self.searchDelegate?.didReceiveMovies(data.search)
                case .failure(let error):
                    self.delegate?.didReceiveError(error.localizedDescription)
                }
            }
            
        }
    }
}
