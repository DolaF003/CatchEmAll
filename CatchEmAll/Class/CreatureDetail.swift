//
//  CreatureDetail.swift
//  CatchEmAll
//
//  Created by Dola Fakeye on 10/27/25.
//

import Foundation

@Observable
class CreatureDetail {
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var other: Other
    }
    
    struct Other: Codable {
        var officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Codable {
        var front_default: String? //This might return null
    }
    
    var urlString = ""
    var height = 0.0
    var weight = 0.0
    var imageURL = ""
    
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
            self.height = returned.height
            self.weight = returned.weight
            self.imageURL = returned.sprites.other.officialArtwork.front_default ?? "n/a"
        } catch {
            print("😡 JSON Error: Could not use URL at \(urlString) to get data and repsonse")
        }
    }
}
