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
    var isLoading = false
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        isLoading = true

        //convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡 JSON ERROR: Could not decode returned JSON data")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            //Try to decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON Error: Could not decode returned JSON data")
                isLoading = false
                return
            }
            Task { @MainActor in
                self.count = returned.count
                self.urlString = returned.next ?? ""
                self.creaturesArray = self.creaturesArray + returned.results
                isLoading = false
            }
            
        } catch {
            print("😡 JSON Error: Could not use URL at \(urlString) to get data and repsonse")
            isLoading = false
        }
    }
    
    func loadAll() async {
        Task {@MainActor in
            guard urlString.hasPrefix("http") else {return}
            await getData() //get next page of data
            await loadAll() //call loadALL again - will stop when all pages are retrieved
        }
    }
}
