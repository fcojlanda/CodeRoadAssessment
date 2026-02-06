struct SearchResponse: Decodable {
    let search: [MovieDTO]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
