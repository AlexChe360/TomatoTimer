//
//  CircularProgressBarView.swift
//  TomatoTimer
//
//  Created by Alex on 18.01.2024.
//

import UIKit

class CircularProgressBarView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let labelSize: CGFloat = 50
        static let height: CGFloat = 250
        static let x: CGFloat = 115
        static let y: CGFloat = 115
    }
    
    // MARK: - UI
    
    private var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "00:00:000"
        label.textColor = UIColor.green
        label.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .light)
        return label
    }()
    
    private var startStopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = UIColor.green
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Properties
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var timer: Timer?
    private var isStarted: Bool = false
    private var isWorkTime: Bool = false
    private var workTime: Double = 10.0
    private var relaxTime: Double = 5.0
    private lazy var duration = workTime
    
    private var progressColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    private var trackColor = UIColor.lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        createCircularPath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timerLabel.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        timerLabel.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        
        let buttonSize: CGFloat = 60
        startStopButton.frame = CGRect(x: bounds.size.width / 2 - 30 , y: bounds.size.height / 2 + 40, width: buttonSize, height: buttonSize)
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubviews([
            timerLabel,
            startStopButton
        ])
        setTimeLabel(value: duration)
        startStopButton.addTarget(self, action: #selector(startStopTapped), for: .touchUpInside)
    }
    
    // MARK: - Other functions
    
    private func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width / 2
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 1.5) / 2, startAngle: -CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 5.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isStarted = true
        startStopButton.setImage(UIImage(systemName: "pause"), for: .normal)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        isStarted = false
        isWorkTime = false
        startStopButton.setImage(UIImage(systemName: "play"), for: .normal)
    }
    
    private func changeProgressLayerColor(to newColor: UIColor) {
        progressLayer.strokeColor = newColor.cgColor
    }
    
    private func chageButtonLabelColor(to newColor: UIColor) {
        timerLabel.textColor = newColor
        startStopButton.tintColor = newColor
    }
    
    private func setTimeLabel(value: Double) {
        let minutes = Int(value / 60)
        let seconds = Int(value - Double(minutes) * 60 * 100)
        let milisec = Int((value - Double(Int(value))) * 1000)
        timerLabel.text = String(format: "%02d:%02d:%03d", minutes, seconds, milisec)
    }
    
    // MARK: - Actions
    
    @objc func startStopTapped() {
        if isStarted {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    @objc func updateTimer() {
        duration -= 0.001
        setTimeLabel(value: duration)
        if duration <= 0 {
            if isWorkTime {
                changeProgressLayerColor(to: .green)
                chageButtonLabelColor(to: .green)
            } else {
                changeProgressLayerColor(to: .red)
                chageButtonLabelColor(to: .red)
            }
            isWorkTime.toggle()
            duration = isWorkTime ? relaxTime : workTime
            setTimeLabel(value: duration)
        }
    }
}
