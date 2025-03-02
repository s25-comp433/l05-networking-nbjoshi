//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var opponent: String
    var team: String
    var date: String
    var id: Int
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var opponent: Int
    var unc: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                HStack {
                    Text("\(item.team) vs. \(item.opponent)")
                    Spacer()
                    Text("\(item.score.unc) - \(item.score.opponent)")
                }
                HStack {
                    Text("\(item.date)")
                    Spacer()
                    Text(item.isHomeGame ? "Home" : "Away")
                }
                .foregroundStyle(.secondary)
                .font(.caption)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
