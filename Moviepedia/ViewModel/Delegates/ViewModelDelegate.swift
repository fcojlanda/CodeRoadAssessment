import Foundation

protocol ViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didReceiveError(_ error: String)
}

