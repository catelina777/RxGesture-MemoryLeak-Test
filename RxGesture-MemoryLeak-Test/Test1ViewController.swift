//
//  Test1ViewController.swift
//  RxGesture-MemoryLeak-Test
//
//  Created by Ryuhei Kaminishi on 2019/06/15.
//  Copyright © 2019 catelina777. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class Test1ViewController: UIViewController {

    @IBOutlet weak var imageView: TestImageView!
    @IBOutlet weak var popButton: UIButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare for transition
        popButton.rx.tap
            .bind(to: pop)
            .disposed(by: disposeBag)

        // Subscribe on child view
        imageView.subscribe()

        // Subscribe on child view and cause circular references
        // imageView.causeCircularReferences()

        // Subscribe on super view
        subscribeOnSuperView()

        // Subscribe on super view and cause circular references
        // causeCircularReferences()
    }

    deinit {
        print("🧹🧹🧹 Test1ViewController memory released 🧹🧹🧹")
    }

    var setRecognizer: Binder<UIPinchGestureRecognizer> {
        return Binder(self) { me, recognizer in
            me.imageView.gestureRecognizers = [recognizer]
        }
    }

    var pop: Binder<Void> {
        return Binder(self) { me, _ in
            me.navigationController?.popViewController(animated: true)
        }
    }

    private func subscribeOnSuperView() {
        print("subscribe on superview")
        // This code is said to have a problem
        imageView.rx.pinchGesture()
            .asDriver()
            .skip(1)
            .drive(onNext: { [unowned self] recognizer in
                self.imageView.gestureRecognizers = [recognizer]
            })
            .disposed(by: disposeBag)


        // Avoid circular references using weak self
        imageView.rx.pinchGesture()
            .asDriver()
            .skip(1)
            .drive(onNext: { [weak self] recognizer in
                guard let me = self else { return }
                me.imageView.gestureRecognizers = [recognizer]
            })
            .disposed(by: disposeBag)


        // Avoid circular references using Binder
        imageView.rx.pinchGesture()
            .skip(1)
            .bind(to: setRecognizer)
            .disposed(by: disposeBag)
    }

    /// 🚨 This code causes circular references
    private func causeCircularReferences() {
        imageView.rx.pinchGesture()
            .asDriver()
            .skip(1)
            .drive(onNext: { recognizer in
                self.imageView.gestureRecognizers = [recognizer]
            })
            .disposed(by: disposeBag)
    }
}
