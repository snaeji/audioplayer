import Flutter
import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import os

public class SwiftAudioplayerPlugin: NSObject, FlutterPlugin {
    
    var playerVC: PlayerVC?
    var first = true
    public static var viewController = UIViewController()

    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bz.rxla.flutter/audio", binaryMessenger: registrar.messenger())
    let instance = SwiftAudioplayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    viewController = (UIApplication.shared.delegate?.window??.rootViewController)!
    
  }
    
    
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        //spilari.present(spilari, animated: true)
        print(call.method)
        
    
      if (call.method == "play" && first) {
        first = false
          let spilari = PlayerVC()
          spilari.source(url: URL(string: "https://ruv-rod.secure.footprint.net/opid/2019/10/23/5069165$5.mp3"))
              spilari.preparePlayer(playerItem: nil, mediaImage: nil, radioImage: nil, title: "asdf")
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(spilari, animated: true, completion: nil);
        }
        SwiftAudioplayerPlugin.viewController.present(spilari, animated: false)
        
              result("iOS " + UIDevice.current.systemVersion)
          }
          else if (call.method == "showAlertDialog") {
        
        
              DispatchQueue.main.async {
                  let alert = UIAlertController(title: "Alert", message: "Hi, My name is flutter", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                  UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil);
              }
        
        
          }
    }
    

}

class PlayerVC: AVPlayerViewController, AVPlayerViewControllerDelegate, AVPictureInPictureControllerDelegate {
    var url: URL?
    var mediaTitle: String?
    var mediaImage: UIImage?
    var squareMediaImage: UIImage?
    let chapterLocalesKey = "availableChapterLocales"
    let assetKeys = ["playable"]
    private var playerItemContext = 192
    var observers = Set<NSKeyValueObservation>()
    var preparingToPlay = false
    var wasPlaying = false
    
    //TODO: Picture In Picture
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showsPlaybackControls = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player?.pause()
        //setupNowPlaying(title: title, mediaImage: squareMediaImage)
        observers.removeAll()
    }
    
    func transferToGlobal() {
//        guard let player = player else {return}
//        //os_log("Transfer from player, player.rate: %g", type: .info, player.rate)
//        if let im = mediaImage {
//            //os_log("MediaImage: %@", type: .info, im.size.debugDescription)
//        }
        if !preparingToPlay {
            //os_log("Transfer from player - Play", type: .info)
//            let global = GlobalSpilari.shared
//            global.playerVC = nil
//            global.mediaIsPlaying = false
//            global.playerVC = self
            //            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            //                os_log("Transfer from player - Play", type: .info)
            //                global.playerVC?.player?.play()
            //                global.mediaIsPlaying = true
            //            }
        }
    }
    
    func transferFromGlobal() {
        //s_log("Transfer to player", type: .info)
        //let global = GlobalSpilari.shared
        //        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        //global.playerVC = nil
        //            global.mediaIsPlaying = false
        //        }
    }
    
    func showPlayerVcAddListeners() {
        //os_log("Adding listeners again for Radio play", type: .info)
        registerPlayback()
        if let observer = player?.observe(\.rate, options: [.old, .new], changeHandler: { (item, change) in
            //os_log("Player rate changed to: %g", type: .info, item.rate)
            // Vista stöðu
            if item.rate < 0.1 {
                //os_log("Player pause", type: .info)
                //let global = GlobalSpilari.shared
                //global.vistaPlayStöðu(playerVC: self)
                
            } else {
                //os_log("Player play", type: .info)
                //GlobalSpilari.shared.mediaIsPlaying = true
            }
        }) {
            observers.insert(observer)
        }
    }
    
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
        return true
    }
    
    func hasFinishedPlaying() {
        //os_log("Finished playing, successfully", type: .info)
        //removePeriodicTimeObserver()
        preparingToPlay = true
        //let global = GlobalSpilari.shared
//        if let url = url {
//            global.vistaSpilunLauk(url: url)
//        }
        
        if presentedViewController != nil {
            presentingViewController?.dismiss(animated: true)
        }
        // Dismiss global player
    }
    
    func registerPlayback() {
        let session = AVAudioSession.sharedInstance()

            do {
//                try session.setCategory(.playback, mode: .default)
//                try session.setActive(true, options: .notifyOthersOnDeactivation)
//            } catch {
//                os_log("Couldn't set category for Radio", type: .error)
//            }
        
        
        // Monitor when playback had ended
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self](item) in
//            let global = GlobalSpilari.shared
//            global.playingHasEnded()
//            guard let self = self else {return}
//            if self.presentingViewController != nil {
//                self.hasFinishedPlaying()
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
        
        // Monitor audisession
//        NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: nil) { [weak self] n in
//            let why = n.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
//            let type = AVAudioSession.InterruptionType(rawValue: why)!
//            switch type {
//            case .began:
//                // update interface if needed
//                if let wasPlaying = self?.wasPlaying {
//                    os_log("wasPlaying was %d", type: .info, wasPlaying)
//                }
//                if let rate = self?.player?.rate, rate > 0.1 {
//                    self?.wasPlaying = true
//                    os_log("wasPlaying set to true", type: .info)
//                }
//                os_log("AVAudioSession Began", type: .info)
//                break
//
//            case .ended:
//                // Check here if audio was playing before interrupt
//                os_log("AVAudioSession Ended", type: .info)
//                if let wasPlaying = self?.wasPlaying, let mediaIsPlaying = GlobalSpilari.shared.mediaIsPlaying {
//                    os_log("wasPlaying ended: %d", type: .info, wasPlaying)
//                    os_log("mediaIsPlaying: %d", type: .info, mediaIsPlaying)
//                }
//                try? AVAudioSession.sharedInstance().setActive(true)
//                // Resume playback
//                if let s = self {
//                    if (GlobalSpilari.shared.mediaIsPlaying == true) {
//                        s.player?.play()
//                        if (GlobalSpilari.shared.isDirect == true) {
//                            os_log("Seeking to front after audio interrupt", type: .info)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
//                                guard let livePosition = s.player?.currentItem?.seekableTimeRanges.last as? CMTimeRange else {
//                                    return
//                                }
//                                s.player?.seek(to:CMTimeRangeGetEnd(livePosition))
//                            }
//                        }
//                    }
//                }
//                os_log("Player playing after interruption", type: .info)
//            @unknown default:
//                break
//            }
//        }
//
//        // MediaService Reset
//        NotificationCenter.default.addObserver(forName: AVAudioSession.mediaServicesWereResetNotification, object: nil, queue: nil) { [weak self](notification) in
//            os_log("MediaServicesWereResetNotification - will close the player", type: .error)
//            self?.dismiss(animated: true)
//        }
//
//        // MediaService Reset
//        NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: nil) { (notification) in
//
//            os_log("MediaRouteChangeNotification - will pause the player", type: .error)
//            MPVolumeSettingsAlertShow()
//        }
//
//
//        NotificationCenter.default.addObserver(forName:AVAudioSession.silenceSecondaryAudioHintNotification, object: nil, queue: nil) { n in
//            let why = n.userInfo![AVAudioSessionSilenceSecondaryAudioHintTypeKey]
//                as! UInt
//            let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: why)!
//            switch type {
//            case .begin:
//                // pause secondary audio
//                os_log("pause secondary audio", type: .info)
//                break
//            case .end:
//                // resume secondary audio
//                os_log("resume secondary audio", type: .info)
//            @unknown default:
//                break
//            }
//        }
    }
    
    // Handle remote events
//    func setupRemoteTransportControls() {
//        let commandCenter = MPRemoteCommandCenter.shared()
//
//        // Play
//        commandCenter.playCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
//            guard let self = self else {return .commandFailed}
//            if let player = self.player, player.rate == 0.0 {
//                player.play()
//                // Athuga hvort global
//                let global = GlobalSpilari.shared
//                if global.playerVC != nil {
//                    if let vc = global.viewController as? TogglesPlay, vc.togglePlay(play:) != nil {
//                        vc.togglePlay!(play: true)
//                    }
//                }
//                self.setupNowPlaying(title: self.title, mediaImage: self.squareMediaImage)
//                return .success
//            }
//            return .commandFailed
//        }
//
//        // Pause
//        commandCenter.pauseCommand.addTarget{ [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
//            guard let self = self else {return .commandFailed}
//            if let player = self.player, player.rate == 1.0 {
//                player.pause()
//                // Athuga hvort global
//                let global = GlobalSpilari.shared
//                if global.playerVC != nil {
//                    if let vc = global.viewController as? TogglesPlay, vc.togglePlay(play:) != nil {
//                        vc.togglePlay!(play: false)
//                    }
//                }
//                self.setupNowPlaying(title: self.title, mediaImage: self.squareMediaImage)
//                return .success
//            }
//            return .commandFailed
//        }
//
//        // PlayPause
//        commandCenter.togglePlayPauseCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
//            guard let self = self else {return .commandFailed}
//            os_log("Er global toggl", type: .debug)
//            if let player = self.player {
//                if player.rate == 0.0 {
//                    player.play()
//                    // Athuga hvort global
//                    let global = GlobalSpilari.shared
//                    if global.playerVC != nil {
//                        os_log("Er global play", type: .debug)
//                        if let vc = global.viewController as? TogglesPlay, vc.togglePlay(play:) != nil {
//                            vc.togglePlay!(play: true)
//                        }
//                    }
//                } else {
//                    player.pause()
//                    // Athuga hvort global
//                    let global = GlobalSpilari.shared
//                    if global.playerVC != nil {
//                        os_log("Er global play", type: .debug)
//                        if let vc = global.viewController as? TogglesPlay, vc.togglePlay(play:) != nil {
//                            vc.togglePlay!(play: false)
//                        }
//                    }
//                }
//                self.setupNowPlaying(title: self.title, mediaImage: self.squareMediaImage)
//                return .success
//            }
//            return .commandFailed
//        }
//
//        // Restart on previous track
//        commandCenter.previousTrackCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
//            guard let self = self else {return .commandFailed}
//            if let player = self.player {
//                let playerRate = player.rate
//                player.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
//                    guard let self = self else {return}
//                    if success {
//                        os_log("Restart at beginning", type: .debug)
//                        self.player?.rate = playerRate
//                        self.setupNowPlaying(title: self.title, mediaImage: self.squareMediaImage)
//                    }
//                })
//                self.setupNowPlaying(title: self.title, mediaImage: self.squareMediaImage)
//                if let url = self.url {
//                    let global = GlobalSpilari.shared
//                    _ = global.getVistadFyrirURL(url, remove: true)
//                }
//                return .success
//            }
//            return .commandFailed
//        }
//
//        // Scrubber
//        commandCenter.changePlaybackPositionCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
//            guard let self = self else {return .commandFailed}
//            if let player = self.player {
//                let playerRate = player.rate
//                if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
//                    let time = event.positionTime
//                    if (GlobalSpilari.shared.isDirect == true) {
//                        if let start = self.player?.currentItem?.seekableTimeRanges.last?.timeRangeValue.start { // let end = self.player?.currentItem?.seekableTimeRanges.last?.timeRangeValue.end
//                            print(event.positionTime)
//                            print(event.positionTime + start.seconds)
//                            player.seek(to: CMTime(seconds: event.positionTime + start.seconds, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
//                                guard let self = self else {return}
//                                if success {
//                                    os_log("Restart at time: %g", type: .debug, time)
//                                    self.player?.rate = playerRate
//                                    self.setupNowPlaying(title: self.title, mediaImage: self.squareMediaImage)
//                                    let global = GlobalSpilari.shared
//                                    global.vistaPlayStöðu(playerVC: self)
//                                }
//                            })
//                        }
//
//                    } else {
//                        player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
//                            guard let self = self else {return}
//                            if success {
//                                os_log("Restart at time: %g", type: .debug, time)
//                                self.player?.rate = playerRate
//                                self.setupNowPlaying(title: self.title, mediaImage: self.squareMediaImage)
//                                let global = GlobalSpilari.shared
//                                global.vistaPlayStöðu(playerVC: self)
//                            }
//                        })
//                    }
//                    return .success
//                }
//            }
//            return .commandFailed
//        }
//
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//    }
    }

    
    // Removetargets
    deinit {
        observers.removeAll()
        removePeriodicTimeObserver()
        //os_log("Remove targets for remote events", type: .info)
        let scc = MPRemoteCommandCenter.shared()
        scc.togglePlayPauseCommand.removeTarget(self)
        scc.playCommand.removeTarget(self)
        scc.pauseCommand.removeTarget(self)
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, timeToSeekAfterUserNavigatedFrom oldTime: CMTime, to targetTime: CMTime) -> CMTime {
        // Update info
        //os_log("playerViewController timeToSeekAfterUserNavigatedFrom", type: .info)
        self.setupNowPlaying(title: self.title, mediaImage: self.mediaImage)
        return targetTime
    }
    
    // Playing Info
    func setupNowPlaying(title: String?, mediaImage: UIImage?) {
//        // Define Now Playing Info
//        mediaTitle = title
//        self.mediaImage = mediaImage
//        var nowPlayingInfo = [String : Any]()
//        if let t = title {
//            nowPlayingInfo[MPMediaItemPropertyTitle] = t
//            nowPlayingInfo[MPMediaItemPropertyArtist] = "RÚV"
//        } else {
//            nowPlayingInfo[MPMediaItemPropertyTitle] = "RÚV"
//        }
//
//        if let image = mediaImage {
//            nowPlayingInfo[MPMediaItemPropertyArtwork] =
//                MPMediaItemArtwork(boundsSize: image.size) { size in
//                    return image
//            }
//        } else {
//            if let mynd = UIImage(named: "ruv_button") {
//                nowPlayingInfo[MPMediaItemPropertyArtwork] =
//                    MPMediaItemArtwork(boundsSize: mynd .size) { size in
//                        return mynd
//                }
//            }
//        }
//
//        if GlobalSpilari.shared.isDirect {
//            if let play = self.player, let item = play.currentItem {
//                if let start = self.player?.currentItem?.seekableTimeRanges.last?.timeRangeValue.start, let end = self.player?.currentItem?.seekableTimeRanges.last?.timeRangeValue.end {
//                    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = item.currentTime().seconds - start.seconds
//                    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = end.seconds - start.seconds
//                    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = play.rate
//                }
//                else {
//                    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = item.currentTime().seconds
//                    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = item.asset.duration.seconds
//                    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = play.rate
//                }
//            }
//        }
//        else {
//            if let play = self.player, let item = play.currentItem {
//                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = item.currentTime().seconds
//                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = item.asset.duration.seconds
//                nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = play.rate
//            }
//        }
//
//        // Set the metadata
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func preparePlayer(playerItem: AVPlayerItem? = nil, mediaImage: UIImage? = nil, play: Bool = true, radioImage: UIImage? = nil, title: String?) {
        // Kill old playerVC
        transferFromGlobal()
        preparingToPlay = true
        self.title = title
        if player == nil {
            player = AVPlayer()
        }
//        if let image = mediaImage {
//            self.mediaImage = image
//            if let croppedImage = image.cropsToSquare() {
//                squareMediaImage = croppedImage
//            }
//            // Ekki mynd fyrir tv
//            if format != .tv {
//                let mynd = UIImageView(image: image)
//                mynd.contentMode = .scaleAspectFill
//                mynd.makeBlurImage(targetImageView: mynd)
//                if let overlay = contentOverlayView {
//                    overlay.fillInto(newView: mynd, useSafeArea: false)
//                }
//                //view.fillInto(newView: mynd, useSafeArea: false)
//            }
//        }
//        self.format = format
//        if let image = radioImage {
//            let mynd = UIImageView(image: image)
//            mynd.contentMode = .scaleAspectFit
//            if let overlay = contentOverlayView {
//                overlay.fillInto(newView: mynd, useSafeArea: false)
//            }
//            //view.fillInto(newView: mynd)
//        }
        registerPlayback()
        
        if (play) {
            player?.play()
//            GlobalSpilari.shared.mediaIsPlaying = true
//            if let observer = player?.observe(\.rate, options: [.old, .new], changeHandler: { (item, change) in
//                os_log("Player rate changed to: %g", type: .info, item.rate)
//                // Vista stöðu
//                if item.rate < 0.1 {
//                    os_log("Player pause", type: .info)
//                    let global = GlobalSpilari.shared
//                    global.vistaPlayStöðu(playerVC: self)
//                    global.mediaIsPlaying = false
//
//                } else {
//                    os_log("Player play", type: .info)
//                    GlobalSpilari.shared.mediaIsPlaying = true
//                }
//            }) {
//                observers.insert(observer)
//            }
        }
        if let playerItem = playerItem {
            player?.replaceCurrentItem(with: playerItem)
        } else {
            if let url = url {
                let asset = AVAsset(url: url)
                let item = AVPlayerItem(asset: asset)
                
                let observer = item.observe(\.status, options: [.old, .new]) { (item, change) in
                    switch item.status {
                    case .readyToPlay:
                        // Set info
                        //os_log("Video loaded: %{private}@", type: .info, url.absoluteString)
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else {return}
                            self.preparingToPlay = false
                            self.setupNowPlaying(title: self.title, mediaImage: self.squareMediaImage)
                        }
                        
                    case .failed: break
                        //os_log("Video failed to load: %{private}@", type: .error, url.absoluteString)
                        
                    case .unknown: break
                        // Not ready yeat
                    @unknown default:
                         break
                    }
                }
                observers.insert(observer)
                player?.replaceCurrentItem(with: item)
                
                // Er vistað?
                //let global = GlobalSpilari.shared
//                if let vistad = global.getVistadFyrirURL(url, remove: true) {
//                    // Spila frá vistuðum stað
//                    player?.seek(to: vistad.time) { [weak self](seeked) in
//                        if !seeked {
//                            os_log("Gat ekki spilað frá tíma: %g sek.", type: .error, vistad.time.seconds)
//                        }
//                        if play {
//                            self?.player?.play()
//                        }
//                    }
//                }
                
            } else {
                //os_log("Villa, vantar url", type: .error)
            }
        }
        //setupRemoteTransportControls()
        //os_log("Player: %@", type: .debug, player?.currentItem?.accessLog() ?? "")
        addPeriodicTimeObserver()
    }
    
    //MARK: - TimeObserver
    
    var timeObserverToken: Any?
    func addPeriodicTimeObserver() {
        // Notify every 1500 ms
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1.5, preferredTimescale: timeScale)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { [weak self](time) in
            guard let self = self else {return}
            self.setupNowPlaying(title: self.title, mediaImage: self.mediaImage)
//            print("Current time")
//            print(self.player?.currentItem?.currentTime())
//            print("Seekable time ranges first")
//            print(self.player?.currentItem?.seekableTimeRanges.first)
//            print(self.player?.currentItem?.seekableTimeRanges.last)
//            print(self.player?.currentItem?.seekableTimeRanges.last?.timeRangeValue.start)
        })
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func source(url: URL?) {
        self.url = url
    }
    
    // Chapters
    
    
    
    
}
