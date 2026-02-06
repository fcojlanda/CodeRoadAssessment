import Foundation
import UIKit

class DetailedVC: UIViewController {
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var evaluationLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var descriptionLabel: UITextView!
    @IBOutlet var titleLabel: UILabel!
    
    private let viewModel = DetailedViewModel()
    var movie: MovieDTO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupView()
    }
    
    private func setupUI() {
        if let movie = movie {
            title = movie.Title
        } else {
            title = "Movie Detail"
        }
        
        posterImage.contentMode = .scaleAspectFit
        descriptionLabel.isEditable = false
        descriptionLabel.isScrollEnabled = false
    }
    
    private func setupView() {
        if let movie = movie {
            titleLabel.text = movie.Title
            yearLabel.text = movie.Year
            evaluationLabel.text = "-"
        } else {
            titleLabel.text = "Sorry!"
            descriptionLabel.text = "No information"
            yearLabel.text = "No information"
            evaluationLabel.text = "No information"
        }
        
        posterImage.image = UIImage(systemName: "photo")
        
        viewModel.delegate = self
        viewModel.detailDelegate = self
        
        getPoster()
    }
    
    private func getPoster() {
        if let movie = movie {
            viewModel.getPosterMovies(movie.imdbID)
        }
    }
}

extension DetailedVC: ViewModelDelegate {
    func didStartLoading() {
        
    }
    
    func didFinishLoading() {
        
    }
    
    func didReceiveError(_ error: String) {
        
    }
}

extension DetailedVC: DetailViewModelDelegate {
    func didReceivePoster(_ data: Data) {
        DispatchQueue.main.async() {
            self.posterImage.image = UIImage(data: data)
        }
    }
}
