//
//  NSMutableAttributedString+Extensions.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return MvFont.GothamBook.of(size: 12) }
    var normalFont:UIFont { return MvFont.GothamBook.of(size: 12) }

    
    func boldText(_ value:String,
                  _ color:UIColor = UIColor.white,
                  _ alignment:NSTextAlignment = .center,
                  _ size:CGFloat = 0) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : MvFont.GothamMedium.of(size: size > 0 ? size : fontSize),
            .foregroundColor : color
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = alignment
        self.addAttribute(NSAttributedString.Key.paragraphStyle,
                          value:paragraphStyle,
                          range:NSMakeRange(0, self.length))
        return self
    }
    
    func normal(_ value:String,
                _ color:UIColor = MvColor.text.convert(),
                _ alignment:NSTextAlignment = .center,
                _ size:CGFloat = 0,
                isNegrita:Bool = false) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : isNegrita ? MvFont.GothamMedium.of(size: size > 0 ? size:fontSize) : MvFont.GothamBook.of(size: size > 0 ? size :fontSize),
            .foregroundColor : color
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = alignment
        self.addAttribute(NSAttributedString.Key.paragraphStyle,
                          value:paragraphStyle,
                          range:NSMakeRange(0, self.length))
        return self
    }
    /* Other styling methods */
    
    func blackHighlight(_ value:String,
                        _ color:UIColor = MvColor.text.convert(),
                        _ alignment:NSTextAlignment = .center,
                        _ size:CGFloat = 0,
                        _ backgroundColor:UIColor = .black,
                        _ isBold:Bool = false) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : isBold ? MvFont.GothamMedium.of(size: size > 0 ? size :fontSize) :
                MvFont.GothamBook.of(size: size > 0 ? size :fontSize),
            .foregroundColor : color,
            .backgroundColor : backgroundColor
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = alignment
        self.addAttribute(NSAttributedString.Key.paragraphStyle,
                          value:paragraphStyle,
                          range:NSMakeRange(0, self.length))
        
        return self
    }
    
    func underlined(_ value:String,
                    _ color:UIColor = MvColor.text.convert(),
                    _ alignment:NSTextAlignment = .center,
                    _ size:CGFloat = 0,
                    _ isBold:Bool = false) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : MvFont.GothamBook.of(size: size > 0 ? size :fontSize),
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .foregroundColor: color
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = alignment
        self.addAttribute(NSAttributedString.Key.paragraphStyle,
                          value:paragraphStyle,
                          range:NSMakeRange(0, self.length))
        
        return self
        
    }

    
    // Helper function inserted by Swift 4.2 migrator.
    func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
    
    func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
}
