//
//  ViewController.swift
//  DrawFigure
//
//  Created by Admin on 18.04.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: [DrawViews]!
    
    
    @IBOutlet weak var backgroundView: DrawViews!
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = ViewsBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        backgroundSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func backgroundSettings(){
        backgroundView.sides = 0
        backgroundView.isHidden = true
        backgroundView.isFaceUp = false
        backgroundView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardBackTapped)))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onCardBackSwiped))
        swipeRecognizer.direction = [.left,.right]
        backgroundView.addGestureRecognizer(swipeRecognizer)
    }
    
    private func initViews(){
        label[0].sides = 0
        label[1].sides = 1
        label[2].sides = 2
        label[3].sides = 3
        label[4].sides = 5
        label[5].sides = 8
        
        for card in label {
            card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardTapped(_:))))
            cardBehavior.addItem(card)
        }
    }
    
    @objc func onCardTapped(_ tap: UITapGestureRecognizer) {
        callCardBack(tap: tap)
    }
    
    private func callCardBack(tap: UITapGestureRecognizer){
        let tappedCard = tap.view as? DrawViews
        
        if let numberOfSides = tappedCard?.sides {
            backgroundView.sides = numberOfSides
        }
        hideBackCard(false)
    }
    
    @objc func onCardBackTapped(tap: UITapGestureRecognizer) {
        switch tap.state {
        case .ended:
            let card = tap.view as? DrawViews
            UIView.transition(with: backgroundView,
                              duration: 0.6,
                              options: [.transitionFlipFromLeft],
                              animations: {[weak self] in
                                card?.isFaceUp = !card!.isFaceUp
                                self?.backgroundView.flipCounter += 1
                },
                completion: { [weak self] _ in
                    if(self?.backgroundView.flipCounter == 2){
                        self?.backgroundView.flipCounter = 0
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.6,
                            delay: 0,
                            options: [],
                            animations: {[weak self] in
                                self?.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                            }, completion: { _ in
                                self?.hideBackCard(true)
                        })
                    }
            })
        default:
            break
        }
    }
    
    @objc func onCardBackSwiped(swipe: UISwipeGestureRecognizer) {
        hideBackCard(true)
    }
    
    func hideBackCard(_ hide: Bool){
        if(hide == true){
            backgroundView.isHidden = true
            for card in label {
                card.isHidden = false
                cardBehavior.addItem(card)
            }
        } else {
            backgroundView.isHidden = false
            for card in label {
                card.isHidden = true
                cardBehavior.removeItem(card)
            }
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.6,
                delay: 0,
                options: [],
                animations: {[weak self] in
                    self?.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            })
        }
        backgroundView.isFaceUp = false
    } 
}

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}

