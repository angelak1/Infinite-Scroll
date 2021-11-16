//
//  ArtPiece.swift
//  Infinite Scroll
//
//  Created by Angela Kearns on 8/19/21.
//

import Foundation

struct DataModel: Decodable, Identifiable {
    var id = UUID()

    var data: [ArtPiece]
    
    private enum CodingKeys : String, CodingKey { case data }
}

struct ArtPiece: Decodable, Identifiable {
    var id = UUID()

    var image_id: String?
    var title: String
    var artist_display: String?
    var date_display: String?
    var medium_display: String?
    var credit_line: String?
    
    var string_image_url: String { return (image_id != nil) ? "https://www.artic.edu/iiif/2/" + image_id! + "/full/full/0/default.jpg" : ""}
    var image_url: URL? {return URL(string: string_image_url)}
    
    private enum CodingKeys : String, CodingKey { case image_id, title, artist_display, date_display, medium_display, credit_line }
}
