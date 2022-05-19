//
//  MainViewController.swift
//  PomodoroTimer
//
//  Created by Roman Korobskoy on 19.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private var isWorkTime: Bool = false
    private var isStarted: Bool = false
    
    private var circleView: CircleView!
    private lazy var timeInterval: TimeInterval = isWorkTime ? 1 * Metrics.relaxTimeMins : 1 * Metrics.workTimeMins
    private lazy var time = Int(timeInterval)
    private var timer = Timer()
    
    private lazy var startPauseButton = UIButton(title: "", titleColor: .mainPurple(), imageName: isWorkTime ? "pause" :"play")
    private lazy var progressLabel = UILabel(text: formatTime(Int(timeInterval)), font: .systemFont(ofSize: 48), color: .mainPurple())
    private lazy var circlesLabel = UILabel(text: "Циклов пройдено: \(circles)", font: .systemFont(ofSize: 35, weight: .bold), color: .mainPurple())
    
    private var timerInterval: Double = 0
    private var circles = 0 {
        didSet {
            circlesLabel.text = "Циклов пройдено: \(circles)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite()
        setUpCircularProgressBarView()
        setConstrainst()
        setupElements()
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
        
    private func setupElements() {
        startPauseButton.addTarget(self, action: #selector(startPauseButtonTapped), for: .touchUpInside)
    }
    
    private func setUpCircularProgressBarView() {
        circleView = CircleView(frame: .zero)
        circleView.center = view.center
        circleView.createCircularPath()
        view.addSubview(circleView)
    }
    
    @objc private func startPauseButtonTapped() {
        //        isWorkTime = isWorkTime ? false : true
        //        startPauseButton.setImage(isWorkTime ? UIImage(systemName: "pause") : UIImage(systemName: "play"), for: .normal)
        startPauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
        if !isStarted {
            startTimer()
            circleView.startResumeAnimation(duration: timeInterval)
            isStarted = true
        } else {
            circleView.pauseAnimation()
            startPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
            timer.invalidate()
            isStarted = false
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if time < 1 {
            circleView.stopAnimation()
            isStarted = false
            timer.invalidate()
            time = Int(timeInterval)
            progressLabel.text = formatTime(Int(timeInterval))
            startPauseButton.setImage(UIImage(systemName: "play"), for: .normal)

            circleView.circleLayer.strokeColor = isWorkTime ? UIColor.mainRed().cgColor : UIColor.mainGreen().cgColor
            circleView.progressLayer.strokeColor = isWorkTime ? UIColor.mainGreen().cgColor : UIColor.mainRed().cgColor
            
            isWorkTime.toggle()
            
            if isWorkTime {
                isWorkTime = true
                isStarted = true
                startTimer()
                time = Int(1.0 * Metrics.relaxTimeMins)
                circleView.startResumeAnimation(duration: Double(time))
                progressLabel.text = formatTime(Int(Metrics.relaxTimeMins) * 1)
                startPauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
                circles += 1
            }
        } else {
            time -= 1
            progressLabel.text = formatTime(time)
        }
    }
}

extension MainViewController {
    private func setConstrainst() {
        view.addSubview(progressLabel)
        view.addSubview(startPauseButton)
        view.addSubview(circlesLabel)
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            startPauseButton.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: Metrics.marginConstant),
            startPauseButton.leadingAnchor.constraint(equalTo: progressLabel.leadingAnchor),
            startPauseButton.trailingAnchor.constraint(equalTo: progressLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            circlesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circlesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70)
        ])
    }
}

private enum Metrics {
    static let workTimeMins = 1.0
    static let relaxTimeMins = 5.0
    
    static let marginConstant: CGFloat = 20
}
