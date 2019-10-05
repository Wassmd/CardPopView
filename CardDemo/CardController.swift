//
//  CardController.swift
//  CardDemo
//
//  Created by Mohammed Wasimuddin on 03.10.19.
//  Copyright © 2019 Wasim. All rights reserved.
//

import UIKit

enum CardState {
    case up
    case down
}

extension CardState {
    var opposite: CardState {
        switch self {
        case .down:
            return .up
        case .up:
            return .down
        }
    }
}

class CardController: UIViewController {
    
    var pullDown: (() -> Void)?
    var pullUp: (() -> Void)?
    var cardCurrentState: CardState = .down

    
    let closeLable: UILabel = {
        let lable = UILabel()
        lable.text = "Card Animation"
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        lable.textColor = .blue
        return lable
    }()
    
    let openLable: UILabel = {
        let lable = UILabel()
        lable.text = "Card Animation"
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        lable.textColor = .black
        lable.alpha = 0.0
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16.0
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        [closeLable, openLable].forEach(view.addSubview)
    }
    
    private func setupConstraints() {
        closeLable.pinHeight(to: 30)
        closeLable.centerHorizontally(to: view)
        closeLable.topEdge(to: view, withOffset: 16)
        
        openLable.pinHeight(to: 30)
        openLable.centerHorizontally(to: view)
        openLable.topEdge(to: view, withOffset: 16)
    }
    
    @objc func buttonAction() {
        print("buttonAction Pan...")
        if cardCurrentState == .down {
            cardCurrentState = .up
        } else {
            cardCurrentState = .down
        }
        
        cardCurrentState == .up ? pullUp?() : pullDown?()
    }
}
