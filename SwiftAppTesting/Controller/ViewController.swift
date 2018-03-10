//
//  ViewController.swift
//  SwiftAppTesting
//
//  Created by MMDC on 10/03/18.
//  Copyright © 2018 Muh.Yusuf. All rights reserved.
//

import UIKit
import AVKit

enum LogoImageEnum {
    case HiddenFirstLogo
    case ShowFirstLogo
    case HiddenSecondLogo
    case ShowSecondLogo
    case HiddenThirdLogo
    case ShowThirdLogo
}

final class ViewController: UIViewController {
    
    lazy private var currentVideo = 1
    lazy private var isAdsOn = false
    private var timer: Timer?
    private var logoTimer: Timer?
    private var statusImage: String = ""
    
    lazy private var logoImageEnum: LogoImageEnum = .ShowFirstLogo
    private var avPlayer: AVPlayer?
    private var avPlayerAds: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
    private var avPlayerLayerAds: AVPlayerLayer?
    lazy private var adsView: UIView = {
        let view = UIView()
        return view
    }()
    lazy private var logoImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    lazy private var menuImageButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initNotification()
        initGesture()
    }

}

// MARK: Private

private extension ViewController {
    func initViews() {
        isAdsOn = false;
        onRequestPlayVideo(path: "video1.mp4")
        onSetTimerShowLogoImage()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setAdsView() {
        let screenSize = UIScreen.main.bounds
        adsView.frame = CGRect(x: 0 ,y: 0, width: screenSize.width, height: screenSize.height)
        adsView.backgroundColor = .clear
        view.addSubview(adsView)
    }
    
    func setLogoImages(nameImage: String) {
        let screenSize = UIScreen.main.bounds
        logoImage.frame = CGRect(x: screenSize.width, y: 30, width: 60, height: 60)
        logoImage.image = UIImage(named: nameImage)
        logoImage.contentMode = .scaleAspectFit
        view.addSubview(logoImage)
        view.bringSubview(toFront: logoImage)
        UIView.animate(withDuration: 1.0) {
            self.logoImage.frame = CGRect(x: screenSize.width - 120, y: 30, width: 60, height: 60)
        }
    }
    
    func setRemoveLogoImage() {
        logoImage.removeFromSuperview()
    }
    
    func setMenuImageButton() {
        menuImageButton.removeFromSuperview()
        menuImageButton.frame = CGRect(x: 70, y: 30, width: 40, height: 40)
        menuImageButton.setImage(UIImage(named: "menu"), for: .normal)
        menuImageButton.addTarget(self, action: #selector(onMenuClicked), for: .touchUpInside)
        view.addSubview(menuImageButton)
        view.bringSubview(toFront: menuImageButton)
    }
    
    func initNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(itemDidFinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
    
    @objc func itemDidFinishPlaying() {
        if isAdsOn == true {
            isAdsOn = false
            self.onResetAdsVideoPlaying()
            return
        }
        onRequestChangeVideoFile()
    }
    
    func initGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    func onRequestPlayVideo(path: String) {
        let filePath = Bundle.main.path(forResource: path, ofType: nil) ?? ""
        let fileURL = NSURL.fileURL(withPath: filePath)
        avPlayer = AVPlayer(url: fileURL)
        avPlayer?.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        avPlayerLayer = AVPlayerLayer.init(player: avPlayer)
        avPlayerLayer?.frame = UIScreen.main.bounds
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(avPlayerLayer!)
        avPlayer?.play()
        onSetTimerShowAds()
        setMenuImageButton()
        view.isUserInteractionEnabled = true
        view.bringSubview(toFront: logoImage)
    }
    
    func onRequestPlayVideoAds(path: String) {
        let filePath = Bundle.main.path(forResource: path, ofType: nil) ?? ""
        let fileURL = NSURL.fileURL(withPath: filePath)
        avPlayerAds = AVPlayer(url: fileURL)
        avPlayerAds?.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        avPlayerLayerAds = AVPlayerLayer.init(player: avPlayerAds)
        avPlayerLayerAds?.frame = UIScreen.main.bounds
        avPlayerLayerAds?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        adsView.layer.addSublayer(avPlayerLayerAds!)
        avPlayerAds?.play()
        view.isUserInteractionEnabled = false
        view.bringSubview(toFront: logoImage)
    }
    
    func onResetVideoPlaying() {
        avPlayer?.pause()
        avPlayer = nil
    }
    
    func onResetAdsVideoPlaying() {
        avPlayerAds?.pause()
        avPlayerAds = nil
        adsView.removeFromSuperview()
        avPlayer?.play()
        view.isUserInteractionEnabled = true
    }
    
    func onRequestChangeVideoFile() {
        if (currentVideo == 1) {
            onResetVideoPlaying()
            onRequestPlayVideo(path: "video2.mp4")
            currentVideo = 2;
        } else {
            onResetVideoPlaying()
            onRequestPlayVideo(path: "video1.mp4")
            currentVideo = 1;
        }
    }
    
    @objc func onShowVideoAds() {
        setAdsView()
        isAdsOn = true
        avPlayer?.pause()
        onRequestPlayVideoAds(path: "videoIklan.mp4")
    }
    
    func onSetTimerShowAds() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 30,
                                     target: self,
                                     selector: #selector(onShowVideoAds),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc func onSwipe() {
        onRequestChangeVideoFile()
    }
    
    @objc func onShowLogoImage() {
        switch logoImageEnum {
        case .HiddenFirstLogo:
            setRemoveLogoImage()
            logoImageEnum = .ShowFirstLogo
        case .ShowFirstLogo:
            setLogoImages(nameImage: "logo1")
            logoImageEnum = .HiddenSecondLogo
        case .HiddenSecondLogo:
            setRemoveLogoImage()
            logoImageEnum = .ShowSecondLogo
        case .ShowSecondLogo:
            setLogoImages(nameImage: "logo2")
            logoImageEnum = .HiddenThirdLogo
        case .HiddenThirdLogo:
            setRemoveLogoImage()
            logoImageEnum = .ShowThirdLogo
        case .ShowThirdLogo:
            setLogoImages(nameImage: "logo3")
            logoImageEnum = .HiddenFirstLogo
        }
    }
    
    func onSetTimerShowLogoImage() {
        logoTimer?.invalidate()
        logoTimer = nil
        logoTimer = Timer.scheduledTimer(timeInterval: 10,
                                     target: self,
                                     selector: #selector(onShowLogoImage),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func onMenuClicked() {
        let menuViewController = MenuViewController.init()
        navigationController?.pushViewController(menuViewController, animated: true)
    }
}
