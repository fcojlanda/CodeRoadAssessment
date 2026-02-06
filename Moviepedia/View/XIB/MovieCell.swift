//
//  MovieCell.swift
//  Moviepedia
//
//  Created by Francisco Landa Torres on 05/02/26.
//

import UIKit

class MovieCell: UITableViewCell {
    static let cellIdentifier = "MovieCellId"
    static let nibName = "MovieCell"
    
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var year: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        movieTitle.font = .boldSystemFont(ofSize: 18)
        movieTitle.numberOfLines = 0
        movieTitle.minimumScaleFactor = 0.5
        
        year.font = .systemFont(ofSize: 14)
        year.textColor = .gray
        
        posterImage.contentMode = .scaleAspectFit
        posterImage.clipsToBounds = true
    }

    func configure(with data: MovieDTO) {
        movieTitle.text = data.Title
        year.text = data.Year
        
        posterImage.image = UIImage(systemName: "photo")
        
        ImageDownloader.shared.downloadImage(from: data.Poster) { [weak self] image in
            self?.posterImage.image = image ?? UIImage(systemName: "photo")
        }
    }
    
}
