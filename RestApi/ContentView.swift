//
//  ContentView.swift
//  RestApi
//
//  Created by Brandon Knox on 4/20/21.
//

import SwiftUI

//struct Response: Codable {
//    var results: [Result]
//}

struct Result: Codable {
    var id: Int
    var title: String
    var code: String
    var linenos: Bool
    var language: String  // = "Python"
    var style: String
}

struct ContentView: View {
//    @State var results = [Result]()
    @State var result = Result(id: 0,
                               title: "",
                               code: "",
                               linenos: false,
                               language: "",
                               style: "")
//    @ObservedObject var query = Query()
    
    var body: some View {
        Form {
            Section {
                Button("Search") {
                    loadData()
                    print("Searching...")
                }
//                List(results, id: \.id) { item in
//                    VStack(alignment: .leading) {
//                        Text(item.title)
//                            .font(.headline)
//                    }
//                }
            }
            VStack {
                Text(String(result.id))
                Text(result.title)
                Text(result.code)
                Text(String(result.linenos))
                Text(result.style)
            }
        }
    }
    
    func loadData() {
        // http://127.0.0.1:8000/snippets/
        // http://127.0.0.1:8000/snippets/2/
        // create the URL we want to read
        guard let url = URL(string: "http://127.0.0.1:8000/snippets/2") else {
            print("Invalid URL")
            return
        }
        
        // wrap url in URLRequest to configure how the URL will be accessed
        let request = URLRequest(url: url)
        
        // create and start a network task from the URLRequest
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result of the networking task
            if let data = data {
                if let decodedResponse = try?JSONDecoder().decode(Result.self, from: data) {
                    DispatchQueue.main.async {
//                        self.results = decodedResponse
                        self.result = decodedResponse
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
