//
//  MapDetail.swift
//  Foodit
//
//  Created by Woody on 6/24/24.
//

import SwiftUI

struct MapDetail: View {
    
    // MARK: Property
    @Binding var id: Int
    @State var name: String = ""
    @State var address: String = ""
    @State var category: String = ""
    @State var review: String = ""
    @State var image: UIImage?
    
    
    // MARK: body View
    var body: some View {
        GeometryReader(content: { geometry in
            VStack(content: {
                if let image{
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 3)
                        .scaledToFit()
                        .padding()
                } // if let
                
                Text("카테고리")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.accent)
                TextField(category, text: $category)
                    .disabled(true)
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(.roundedBorder)
                
                Text("가게명")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.accent)
                TextField(name, text: $name)
                    .disabled(true)
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(.roundedBorder)
                
                Text("가게 주소")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.accent)
                TextField(address, text: $address)
                    .disabled(true)
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                
                
                Text("리뷰")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.accent)
                TextEditor(text: $review)
                    .disabled(true)
                    .border(.gray.opacity(0.2))
                    .frame(width: geometry.size.width / 1.2, height: geometry.size.height / 4.5)
                    .lineLimit(0)

            }) // VStack
            .padding(30)

        }) // GeometryReader
        .onAppear(perform: {
            
            let query = MapDetailQuery()
            let post = query.searchDB(id: id)
            
            name = post[0].name
            address = post[0].address
            category = post[0].category
            image = post[0].image
            review = post[0].review
        }) // onAppear
        
    } // body
     
} // MapDetail

//#Preview {
//    MapDetail(id: .constant(3))
//}
