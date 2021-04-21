//
//  ContentView.swift
//  RestApi
//
//  Created by Brandon Knox on 4/20/21.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var id: Int
    var title: String
    var code: String
    var linenos: Bool
    var language: String  // = "Python"
    var style: String
}

struct ContentView: View {
    @State var results = [Result]()
//    @ObservedObject var query = Query()
    
    var body: some View {
        Form {
            Section {
                Button("Search") {
                    loadData()
                    print("Searching...")
                }
                List(results, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                    }
                }
            }
        }
    }
    
    func loadData() {
        // http://127.0.0.1:8000/snippets/
        // http://127.0.0.1:8000/snippets/2/
        guard let url = URL(string: "http://127.0.0.1:8000/snippets/") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try?JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    print("Results returned")
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            print(request)
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
