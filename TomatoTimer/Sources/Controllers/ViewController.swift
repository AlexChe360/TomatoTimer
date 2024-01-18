//
//  ViewController.swift
//  TomatoTimer
//
//  Created by Alex on 18.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private var progressBar: CircularProgressBarView!
    private var timer: Timer?
    
    // MARK: - Constants
    private enum Constants {
        static let width: CGFloat = 250
        static let height: CGFloat = 250
        static let x: CGFloat = 115
        static let y: CGFloat = 115
    }
    
    // MARK: - UI
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayer()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
        let frame = CGRect(x: view.center.x - Constants.x, y: view.center.y - Constants.y, width: Constants.width, height: Constants.height)
        progressBar = CircularProgressBarView(frame: frame)
    }
    
    private func setupHierarchy() {
        view.addSubviews([
            progressBar
        ])
    }
    
    private func setupLayer() {
        
    }
    
    // MARK: - Other functions
    
    // MARK: - Actions
}

