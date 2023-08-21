import Foundation

struct Propaganda: Codable {
    let id: Int
    let nome: String
    let nomeFile: String
    let imgBase64: String
    let urlDestino: String
}

class PropagandasService: ObservableObject {
    static let shared = PropagandasService()
    
    @Published var propagandas: [Propaganda] = []
    
    init() {}
    
    func fetchPropagandas() {
        guard let url = URL(string: "http://opiniaochat.com.br.hulk.hostazul.com.br/api/Propagandas") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let propagandaArray = try JSONDecoder().decode([Propaganda].self, from: data)
                    DispatchQueue.main.async {
                        self.propagandas = propagandaArray
                    }
                } catch {
                    print("Error decoding propagandas:", error)
                }
            } else if let error = error {
                print("Error fetching propagandas:", error)
            }
        }.resume()
    }
}
