//
//  ContentView.swift
//  Shared
//
//  Created by Angela Kearns on 8/19/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var api = Api()
    @State var nextIndex = 1
    @State var artPieces: [ArtPiece] = []
    @State var nextPage = 1
    
    private let defaultImageUrl = URL(string: "https://www.artic.edu/iiif/2/ffcef98d-6d38-dc75-65e6-cdff009f883c/full/full/0/default.jpg")!
    
    init() {
        self.artPieces = [ArtPiece]()
        api.loadData(page: nextIndex)
    }
    
    var body: some View {
        NavigationView {
            List(api.artPieces.indices, id: \.self) { artPieceIndex in
                let artPiece = api.artPieces[artPieceIndex]
                VStack{
                    Text(artPiece.title)
                        .padding(.vertical, 15)
                        .font(.headline)
                    AsyncImage(url: artPiece.image_url ?? defaultImageUrl, placeholder: {Color.gray}, image: {image in
                                Image(uiImage: image)
                                    .resizable()
                                }).aspectRatio(contentMode: .fit)
                    Text(artPiece.artist_display ?? "")
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(artPiece.date_display ?? "")
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .padding(.bottom, 5)
                    Text(artPiece.credit_line ?? "")
                        .font(.caption)
                        .padding(.bottom, 15)
                }
                .onAppear() {
                    if api.artPieces.count < 2 {
                        nextIndex += 1
                        api.loadData(page: nextIndex)
                    }
                    else if artPieceIndex == api.artPieces.count - 2 {
                        nextIndex += 1
                        api.loadData(page: nextIndex)
                    }
                }
            }.navigationTitle("Art")
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}
