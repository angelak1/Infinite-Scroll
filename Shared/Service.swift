//
//  Service.swift
//  Infinite Scroll
//
//  Created by Angela Kearns on 8/19/21.
//

import Foundation

class Api: ObservableObject {
    @Published var artPieces = [ArtPiece]()
    
    func loadData(page: Int) {
        let url = "https://api.artic.edu/api/v1/artworks"
        let url_str = url + "?page=" + String(page)
        let url_with_page = URL(string: url_str)
        guard let requestUrl = url_with_page else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Decode HTTP Response Data using the data model
            if let data = data {
                do {
                    let dataModel = try JSONDecoder().decode(DataModel.self, from: data)
                    DispatchQueue.main.async {
                        for data in dataModel.data {
                            if data.image_url != nil {
                                self.artPieces.append(data)
                            }
                        }
                    }
                }
                catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
            
        }
        task.resume()
    }
}



