//
//  NFCViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import Foundation
import CoreNFC
import Combine

/// nfc 읽기 테스트
class NFCViewModel: NSObject, ObservableObject {
    
    let readedNfcInfo = PassthroughSubject<Data, Never>()
    let readedNfcInfoError = PassthroughSubject<NSError, Never>()
    
    var nfcSession: NFCNDEFReaderSession!
    
    @Published var nfcInfo: Data?
    @Published var nfcInfoText = ""
    
    override init() {
        
        super.init()
        
        self.nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    }
}


extension NFCViewModel: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        
        self.readedNfcInfoError.send(error as NSError)
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        // 감지된 NFC 태그 정보 처리
        for message in messages {
            // 태그의 메시지 내용 출력
            guard let tag = message.records.first?.payload else {
                return
            }
            
            self.readedNfcInfo.send(tag)
            self.nfcInfoText = tag.base64EncodedString()
            break
        }
    }
}
