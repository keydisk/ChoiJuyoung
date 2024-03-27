//
//  TextStyleModifier.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/25/24.
//

import SwiftUI

struct TextStyleModifier: ViewModifier {
    
    var isBlack = false
    
    func body(content: Content) -> some View {
  
        content.foregroundColor(isBlack ? Color.black : Color.gray).font(.spoqaRegular(fontSize: 20))
    }
    
}
