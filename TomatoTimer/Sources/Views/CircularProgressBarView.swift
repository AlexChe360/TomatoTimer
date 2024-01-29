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
    
    private var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .light)
        return label
    }()
    
    private var startStopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = UIColor.red
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .clear
        return button
    }()
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var timer: Timer?
    private var isStarted: Bool = false
    private var isWorkTime: Bool = false
    private var duration = 120
    private var elapsedTime = 0
    private var workTime: Int = 10
    private var relaxTime: Int = 5
    
    
    var progressColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
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
    
    private func setupView() {
        addSubviews([
            timerLabel,
            startStopButton
        ])
        startStopButton.addTarget(self, action: #selector(startStopTapped), for: .touchUpInside)
    }
    
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
        if !isStarted {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isStarted = true
            isWorkTime = true
            startStopButton.setImage(UIImage(systemName: "pause"), for: .normal)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        isStarted = false
        startStopButton.setImage(UIImage(systemName: "play"), for: .normal)
    }
    
    private func changeProgressLayerColor(to newColor: UIColor) {
        progressLayer.strokeColor = newColor.cgColor
    }
    
    private func chageButtonLabelColor(to newColor: UIColor) {
        timerLabel.textColor = newColor
        startStopButton.tintColor = newColor
    }
    
    func setProgress(to progressConstant: CGFloat, withAnimation: Bool) {
        var progress = progressConstant
        if progressConstant > 1.0 {
            progress = 1.0
        } else if progressConstant < 0.0 {
            progress = 0.0
        }
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 2
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = progress
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            progressLayer.strokeEnd = progress
            progressLayer.add(animation, forKey: "animateProgress")
        } else {
            progressLayer.strokeEnd = progress
        }
    }
    
    func setTimeLabel(value: Int) {
        let minutes = value / 60
        let seconds = value % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func startStopTapped() {
        if isStarted {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    @objc func updateTimer() {
        if elapsedTime < duration {
            elapsedTime += 1
            let progress = CGFloat(elapsedTime) / CGFloat(duration)
            setProgress(to: progress, withAnimation: false)
            setTimeLabel(value: duration - elapsedTime)
            
            if elapsedTime % workTime == 0 {
                changeProgressLayerColor(to: .green)
                chageButtonLabelColor(to: .green)
            } else if elapsedTime % relaxTime == 0 {
                changeProgressLayerColor(to: .red)
                chageButtonLabelColor(to: .red)
            }
            
        } else {
            elapsedTime = 0
            setProgress(to: 0, withAnimation: false)
            setTimeLabel(value: duration)
            startTimer()
        }
    }
    
}
