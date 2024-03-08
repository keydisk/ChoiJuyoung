//
//  RoundTextField.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI

struct RoundTextField: View {
    
    @State var round: CGFloat
    @Binding var text: String
    let placeHolder: String
    let edge: EdgeInsets
    
    init(round: CGFloat, text: Binding<String>, placeHolder: String, edge: EdgeInsets) {
        
        self.round = round
        self._text = text
        self.placeHolder = placeHolder
        self.edge = edge
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10).stroke(Color.black).overlay(content: {
            
            TextField(self.placeHolder, text: $text).padding(self.edge)
        })
    }
}
