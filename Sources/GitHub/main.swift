
import ArgumentParser
import Foundation
import Alamofire

struct GetRepositories: ParsableCommand {

    static let configuration = CommandConfiguration(abstract: "Input User name to get list of repositories")
    
    @Argument(help: "Name of user to get list of repositories")
    var userName: String
    
    func run() throws {
        getRepos(userName: userName)
    }
    
    func validate() throws {
        guard check(userName: userName) else {
            throw ValidationError("Check your username")
        }
    }
    
    private func getRepos(userName: String) {
        let urlString = "https://api.github.com/users/\(userName)/repos"
    
        guard let url = URL(string: urlString) else {
            print("failed to create url")
            return }
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let value = value as? [[String: Any]] else {
                    print("faied to get repositories, check user name")
                    return  }
                let names: [String?] = value.map( { $0["name"] as? String })
                names.forEach { print($0 ?? "") }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func check(userName: String) -> Bool {
        let regEx = "^[a-zA-Z0-9-\\.]{1,38}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return (predicate.evaluate(with: userName))
    }
}

GetRepositories.main()
RunLoop.main.run(until: Date(timeIntervalSinceNow: 10))



