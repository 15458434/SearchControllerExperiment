//
//  DetailCurrency.swift
//  SearchControllerExperiment
//
//  Created by Mark Cornelisse on 06/01/16.
//  Copyright © 2016 Over de muur producties. All rights reserved.
//

import UIKit
import CurrencyConverter

class DetailCurrency: UIViewController {
    // MARK: Properties
    var currency: Currency?
    
    // MARK: IB Outlets
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    
    // MARK: IB Actions
    
    // MARK: New in this class
    
    func attributedStringForLabel(string: String) -> NSAttributedString {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let attrs = [NSFontAttributeName: font]
        return NSAttributedString(string: string, attributes: attrs)
    }
    
    // MARK: Inherited from super
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currency == nil {
            nameLabel.attributedText = attributedStringForLabel("")
            symbolLabel.attributedText = attributedStringForLabel("")
            codeLabel.attributedText = attributedStringForLabel("")
        } else {
            nameLabel.attributedText = attributedStringForLabel(currency!.name)
            symbolLabel.attributedText = attributedStringForLabel(currency!.symbol)
            codeLabel.attributedText = attributedStringForLabel(currency!.code)
        }
    }
}