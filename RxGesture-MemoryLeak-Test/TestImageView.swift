//
//  TestImageView.swift
//  RxGesture-MemoryLeak-Test
//
//  Created by Ryuhei Kaminishi on 2019/06/15.
//  Copyright © 2019 catelina777. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class TestImageView: UIImageView {

    private let disposeBag = DisposeBag()

    func subscribe() {
        print("subscribe on child view")
        
        // This code is said to have a problem
        rx.pinchGesture()
            .asDriver()
            .skip(1)
            .drive(onNext: { [unowned self] recognizer in
                self.gestureRecognizers = [recognizer]
            })
            .disposed(by: disposeBag)

        // Avoid circular references using weak self
        rx.pinchGesture()
            .asDriver()
            .skip(1)
            .drive(onNext: { [weak self] recognizer in
                guard let me = self else { return }
                me.gestureRecognizers = [recognizer]
            })
            .disposed(by: disposeBag)

        // Avoid circular references using Binder
        rx.pinchGesture()
            .skip(1)
            .bind(to: setRecognizer)
            .disposed(by: disposeBag)
    }

    deinit {
        print("🧹🧹🧹 release TestImageView 🧹🧹🧹")
    }

    var setRecognizer: Binder<UIPinchGestureRecognizer> {
        return Binder(self) { me, recognizer in
            me.gestureRecognizers = [recognizer]
        }
    }
}
