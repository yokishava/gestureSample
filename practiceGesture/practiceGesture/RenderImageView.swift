//
//  RenderImageView.swift
//  practiceGesture
//
//  Created by 吉川昂広 on 2018/05/12.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

class RenderImageView: UIImageView {
    
    // 画像の拡大率
    private var currentScale:CGFloat = 1.0
    private var maxScale: CGFloat!
    private var scaleArray: [CGFloat] = []
    private var specifiedMaxScale = false
    private var startScale: CGAffineTransform!
    
    private var locationInitialTouch:CGPoint!
    
    enum BehaviorMode : Int{
        case None
        case MoveWindowPosition
        case ChangeWindowSize
    }
    
    private var behaviorMode:BehaviorMode = .None
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.frame = CGRect(x: 70, y: 200, width: 200, height: 200)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        self.addGestureRecognizer(pinchGesture)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pinchAction(_ sender: UIPinchGestureRecognizer) {
        // imageViewを拡大縮小する
        // ピンチ中の拡大率は0.3〜2.5倍、指を離した時の拡大率は0.5〜2.0倍とする
        switch sender.state {
        case .began:
            startScale = self.transform
        case .changed:
            // senderのscaleは、指を動かしていない状態が1.0となる
            // 現在の拡大率に、(scaleから1を引いたもの) / 10(補正率)を加算する
            currentScale = currentScale + (sender.scale - 1) / 10
            // 拡大率が基準から外れる場合は、補正する
            if currentScale < 0.3 {
                currentScale = 0.3
            } else if currentScale > 2.5 {
                currentScale = 2.5
            }
            
            //すでに画面の境界に位置してpinchActionをしても拡大しない
            if self.frame.origin.x == 0 || self.frame.origin.y == 0 || self.frame.maxX == UIScreen.main.bounds.width || self.frame.maxY == UIScreen.main.bounds.height {
                
                break

            } else {
                // 計算後の拡大率で、imageViewを拡大縮小する
                self.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
                scaleArray.append(currentScale)
                
                //拡大していって画面の境界を超えた時、超える直前のcurrentScaleを使用する
                if self.frame.origin.x < 0 || self.frame.origin.y < 0 || self.frame.maxX > UIScreen.main.bounds.width || self.frame.maxY > UIScreen.main.bounds.height {
                    
                    if !specifiedMaxScale {
                        maxScale = scaleArray[self.scaleArray.count - 1]
                        specifiedMaxScale = true
                    }
                    self.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
                }
            }
        default:
            if currentScale < 0.5 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: nil)
            }
            
            //リセット
            scaleArray.removeAll()
            specifiedMaxScale = false
            //currentScaleをリセットしていなかったから次のpinchGestureのときに2.5からスタートしてた
            currentScale = 1.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            //let location = touch.locationInView(self)
            print("Began:(\(location.x), \(location.y))")
            locationInitialTouch = location
            
//            if location.x > bounds.width - 20 && location.y > bounds.height - 20{
//                behaviorMode = .ChangeWindowSize
//            }else{
//                behaviorMode = .MoveWindowPosition
//            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            //let location = touch.locationInView(self)
            print("Moved:(\(location.x), \(location.y))")
            
//            if behaviorMode == .ChangeWindowSize {
//                frame = CGRect(origin: frame.origin, size: CGSize(width: location.x, height: location.y ))
//            }else{
            frame = frame.offsetBy(dx: location.x - locationInitialTouch.x, dy: location.y - locationInitialTouch.y)
            if frame.origin.x < 0 {
                frame.origin.x = 0
            }
            if frame.origin.y < 0 {
                frame.origin.y = 0
            }
            if frame.maxX > UIScreen.main.bounds.width {
                frame.origin.x = UIScreen.main.bounds.width - frame.width
            }
            if frame.maxY > UIScreen.main.bounds.height {
                frame.origin.y = UIScreen.main.bounds.height - frame.height
            }
            //}
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            //let location = touch.locationInView(self)
            print("Ended:(\(location.x), \(location.y))")
            
//            if behaviorMode == .ChangeWindowSize {
//                frame = CGRect(origin: frame.origin, size: CGSize(width: location.x, height: location.y ))
//            }else{
            frame = frame.offsetBy(dx: location.x - locationInitialTouch.x, dy: location.y - locationInitialTouch.y)
            if frame.origin.x < 0 {
                frame.origin.x = 0
            }
            if frame.origin.y < 0 {
                frame.origin.y = 0
            }
            if frame.maxX > UIScreen.main.bounds.width {
                frame.origin.x = UIScreen.main.bounds.width - frame.width
            }
            if frame.maxY > UIScreen.main.bounds.height {
                frame.origin.y = UIScreen.main.bounds.height - frame.height
            }
            //}
            //behaviorMode = .None
        }
    
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
