//
//  NoodlesViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import UIKit

protocol FlowControlable: UIViewController {
	associatedtype ConcreteDirector

	var flowDelegate: ConcreteDirector! { get set }
}


class NoodlesViewController: UIViewController {
}
