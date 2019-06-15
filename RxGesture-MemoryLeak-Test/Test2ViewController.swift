//
//  Test2ViewController.swift
//  RxGesture-MemoryLeak-Test
//
//  Created by Ryuhei Kaminishi on 2019/06/15.
//  Copyright © 2019 catelina777. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class Test2ViewController: UIViewController {

    @IBOutlet weak var popButton: UIButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        popButton.rx.tap
            .bind(to: push)
            .disposed(by: disposeBag)
    }

    deinit {
        print("🧹🧹🧹 Test2ViewController memory released 🧹🧹🧹")
    }

    var push: Binder<Void> {
        return Binder(self) { me, _ in
            let vc = Test1ViewController()
            me.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

