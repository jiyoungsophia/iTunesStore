//
//  Reactive+UILabel.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    var tapGesture: Observable<Void> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        
        base.addGestureRecognizer(tapGestureRecognizer)
        base.isUserInteractionEnabled = true

        return tapGestureRecognizer.rx.event
            .map { _ in () }
            .asObservable()
    }
}
