import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func didReceivePoster(_ data: Data)
}

final class DetailedViewModel {
    weak var delegate: ViewModelDelegate?
    weak var detailDelegate: DetailViewModelDelegate?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func getPosterMovies(_ identifier: String) {
        delegate?.didStartLoading()
        
        guard let endpoint = URL(string: "http://img.omdbapi.com/?apikey=7be98d2c&i=\(identifier)") else {
            delegate?.didReceiveError("Invalid URL")
            return
        }
        
        networkService.requestData(url: endpoint) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }
            
            self.delegate?.didFinishLoading()
            
            switch result {
            case .success(let data):
                self.detailDelegate?.didReceivePoster(data)
            case .failure(let error):
                self.delegate?.didReceiveError(error.localizedDescription)
            }
        }
    }
}
