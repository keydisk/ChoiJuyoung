//
//  BookMetaInfoView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/20/24.
//

import SwiftUI
import Kingfisher

/// 책 간단 정보
struct BookMetaInfoView: View {
    
    let model: BookModel!
    @State var width: CGFloat = 100
    let viewModel: DetailViewModel
    @Binding var sendView: Bool
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            KFImage(URL(string: self.model.thumbnail)).applyDefaultBookImg("emptyImg").onSuccess({result in
                
                self.width = result.image.size.width
            }).resizable().padding(1)
            
            Text(self.model.title).font(.defaultFont).foregroundColor(.gray).padding(.top, 6).lineLimit(1).onTapGesture {
                
                viewModel.sendDataUpperView.send(model)
                sendView = true
            }
            Text(self.model.printDateWithoutTitle).font(.defaultFont).foregroundColor(.gray).padding(.top, 5).lineLimit(1)
        }.frame(width: self.width).background(
            
            RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1)
        ).cornerRadius(5).padding(2)
    }
}

