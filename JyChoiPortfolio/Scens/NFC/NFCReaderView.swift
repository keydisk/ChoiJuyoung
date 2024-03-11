//
//  NFCReaderView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import SwiftUI

struct NFCReaderView: View {
    
    let viewModel = NFCViewModel()
    
    init() {
        
    }
    
    var body: some View {
        
        Text(viewModel.nfcInfoText)
    }
}

#Preview {
    NFCReaderView()
}
