//
//  ViewController.swift
//  CardDemo
//
//  Created by Mohammed Wasimuddin on 03.10.19.
//  Copyright © 2019 Wasim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1)
    private let cardViewController = CardController()
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hello!", for: .normal)
        button.backgroundColor = .gray
        
        return button
    }()
    
    var topCardConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupSubviews()
        setupChildControllerView()
        setupConstraints()
        setupObserver()
        
    }
    
    private func setupSubviews() {
        view.addSubview(button)
    }
    
    private func setupChildControllerView() {
        addChild(cardViewController)
        view.addSubview(cardViewController.view)
        cardViewController.didMove(toParent: self)
        
        let panGesture = InstantPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        cardViewController.view.addGestureRecognizer(panGesture)
    }
    
    private func setupConstraints() {
        button.pinSize(to: CGSize(width: 100, height: 30))
        button.centerVertically(to: view)
        button.centerHorizontally(to: view)
        
        topCardConstraint = cardViewController.view.topEdge(to: view.safeAreaLayoutGuide, withOffset: view.bounds.height - 100)
        cardViewController.view.pinLeadingAndTrailingEdges(to: view)
        cardViewController.view.pinHeight(to: view.bounds.height)
    }
    
    private func setupObserver() {
        cardViewController.pullDown = { [weak self] in
            guard let self = self else { return }
            self.animateCard(with: self.view.bounds.height - 100)
        }
        
        cardViewController.pullUp = { [weak self] in
            self?.animateCard(with: 100)
        }
    }
    
    
    private func animateCard(with topOffset: CGFloat) {
        let state = cardViewController.cardCurrentState.opposite
        // dampingRatio to oscillate, set one for no oscillation
        animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5)
        animator.addAnimations { [weak self] in
            guard let self = self else { return }
            
            switch self.cardViewController.cardCurrentState {
            case .down:
                self.topCardConstraint?.constant = 100
            case .up:
                self.topCardConstraint?.constant = self.view.bounds.height - 100
            }
            
            
            self.animateLable()
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
           
            switch position {
            case .start:
                self.cardViewController.cardCurrentState = state.opposite
                 print("animation completed start ....\(self.cardViewController.cardCurrentState)")
            case .current:
                ()
            case .end:
                self.cardViewController.cardCurrentState = state
                 print("animation completed end ....\(self.cardViewController.cardCurrentState)")
            @unknown default:
                fatalError()
            }
            
            switch self.cardViewController.cardCurrentState {
            case .down:
                self.topCardConstraint?.constant = self.view.bounds.height - 100
            case .up:
                 self.topCardConstraint?.constant = 100
            }
        }
        
        
        animator.startAnimation()
    }
    
    private var animationProgress: CGFloat = 0
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let offset = cardViewController.cardCurrentState == .down ? 100 : view.bounds.height - 100
        
        switch recognizer.state {
        case .began:
            animateCard(with: offset)
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
       
        case .changed:
            
            let translation = recognizer.translation(in: cardViewController.view)
            var fraction = -translation.y / offset
            if cardViewController.cardCurrentState == .up || animator.isReversed { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
        
        case .ended:
            
            let yVelocity = recognizer.velocity(in: cardViewController.view).y
            let shouldClose = yVelocity > 0
            if yVelocity == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            switch cardViewController.cardCurrentState {
            case .up:
                if !shouldClose && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if shouldClose && animator.isReversed { animator.isReversed = !animator.isReversed }
            case .down:
                if shouldClose && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if !shouldClose && animator.isReversed { animator.isReversed = !animator.isReversed }
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        @unknown default:
            print("default")
            break
        }
    }
    
    private func animateLable() {
        switch cardViewController.cardCurrentState {
        case .down:
            cardViewController.closeLable.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
            cardViewController.openLable.transform = .identity
            cardViewController.closeLable.alpha = 0.0
            cardViewController.openLable.alpha = 1.0
        case .up:
            cardViewController.openLable.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
            cardViewController.closeLable.transform = .identity
            cardViewController.openLable.alpha = 0.0
            cardViewController.closeLable.alpha = 1.0
        }
    }
}

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
}
