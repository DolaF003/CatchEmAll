//
//  Creatures.swift
//  CatchEmAll
//
//  Created by Dola Fakeye on 10/27/25.
//

import Foundation

@MainActor
@Observable
class Creatures {
    private struct Returned: Codable {
        var count: Int
        var next: String?
        var results: [Creature]
    }
    
    
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    var count = 0
    var creaturesArray: [Creature] = []
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        //convert urlString to a special URL type
        
        guard let url = URL(string: urlString) else {
            print("😡 JSON ERROR: Could not decode returned JSON data")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            //Try to decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON Error: Could not decode returned JSON data")
                return
            }
            Task { @MainActor in
                self.count = returned.count
                self.urlString = returned.next ?? ""
                self.creaturesArray = self.creaturesArray + returned.results
            }
        } catch {
            print("😡 JSON Error: Could not use URL at \(urlString) to get data and repsonse")
        }
    }
}
