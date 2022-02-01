//
//  TOPEncryptionTool.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 01/02/22.
//

import UIKit
import CryptoSwift
//
// MARK Encrytion data
class EncryptionTool {
    
    static let share = EncryptionTool()
    
    // MARK: - Public methods
    func encrypString(string: String) -> String? {
        guard let bytePassword = self.getPassword() else {
            return nil
        }
        
        var stringArray = [UInt8]()
        for char in string.utf8 {
            stringArray.append(char)
        }
        
        do {
            let aes = try AES(key: bytePassword, blockMode: CBC(iv: bytePassword), padding: .pkcs5)
            let cipherText = try aes.encrypt(stringArray)
            
            return cipherText.toBase64()
            
        } catch {
            return nil
        }
    }
    
    func decrypString(string64: String) -> String? {
        guard let bytePassword = self.getPassword() else {
            return nil
        }
        
        do {
            let arrayByte = [UInt8](base64: string64)
            
            let aes = try AES(key: bytePassword, blockMode: CBC(iv: bytePassword), padding: .pkcs5)
            let cipherText = try aes.decrypt(arrayByte)
            
            let hexString = cipherText.toHexString()
            return self.hexToString(hex: hexString)
            
        } catch {
            return nil
        }
    }
    
    func hexToString(hex: String) -> String? {
        var hex = hex
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return String(data: data, encoding: .utf8)
    }
    
    private func getPassword() -> [UInt8]? {
        //Example secrect
        let hexPassword = "55444e514d3349314d324e31636a4d3d"
        guard let stringPassword = self.hexToString(hex: hexPassword),
              let base64Data = Data(base64Encoded: stringPassword),
              let keyDecoded = String(data: base64Data, encoding: .utf8) else {
                return nil
        }
        
        var byteArray = [UInt8](repeating: 0, count: 16)
        
        var i = 0
        for char in keyDecoded.utf8 {
            byteArray[i] = char
            i += 1
        }
        return byteArray
    }
    
}
