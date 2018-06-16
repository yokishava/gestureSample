//
//  RenderView.swift
//  practiceGesture
//
//  Created by 吉川昂広 on 2018/06/16.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

class RenderView: UIView {
    
    //現在のscaleを保持する
    private var currentScale:CGFloat = 1.0
    
    //最大のscaleを保持する
    private var maxScale: CGFloat!
    
    //タップ時の最初の座標を保持する
    private var locationIntialTouch: CGPoint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.backgroundColor = UIColor.blue
        //ViewConrollerからorientationが変更した時に通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(judgeViewFrame), name: NSNotification.Name("updateOrientation"), object: nil)
        //拡大、縮小用のrecognizerを追加
        let pinchGesuture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        self.addGestureRecognizer(pinchGesuture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func pinchAction(_ sender: UIPinchGestureRecognizer) {
        //アクション中にどんどん更新されるscaleを保持するための配列
        var scaleArray: [CGFloat] = []
        
        switch sender.state {
        case .began:
            break
        case .changed:
            // senderのscaleは、指を動かしていない状態が1.0となる
            // 現在の拡大率に、(scaleから1を引いたもの) / 10(補正率)を加算する
            currentScale = currentScale + (sender.scale - 1) / 10
            // ピンチ中の拡大率は0.3〜2.5倍、指を離した時の拡大率は0.5〜2.0倍とする
            // 拡大率が基準から外れる場合は、補正する
            if currentScale < 0.3 {
                currentScale = 0.3
            } else if currentScale > 2.5 {
                currentScale = 2.5
            }
            
            //拡大、縮小を適用する前に画面の境界に位置していないか確認する
            //境界に位置していた場合は、処理を終える
            guard self.frame.origin.x != 0 else {
                return
            }
            guard self.frame.origin.y != 0 else {
                return
            }
            guard self.frame.maxX != UIScreen.main.bounds.width else {
                return
            }
            guard self.frame.maxY != UIScreen.main.bounds.height else {
                return
            }
            
            //拡大、縮小
            self.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            //適用していくscaleを配列で保持していく
            scaleArray.append(currentScale)
            
            //拡大、縮小して画面からはみ出ていないか確認する
            //はみ出ていなければ、処理を終える
            if self.frame.origin.x < 0 || self.frame.origin.y < 0 || self.frame.maxX > UIScreen.main.bounds.width || self.frame.maxY > UIScreen.main.bounds.height {
                //拡大、縮小してはみ出してしまった場合
                if maxScale == nil {
                   //はみ出る直前のscaleを取得
                   maxScale = scaleArray[scaleArray.count - 1]
                }
                //はみ出ないようにサイズを更新
                self.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
            }
            
        default:
            if currentScale < 0.5 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: nil)
            }
            //アクション終了時で初期化をする
            deinitScale()
        }
    }
    
    private func deinitScale() {
        //currentScaleを初期の1.0に戻す
        //特に指が画面から離れた時に初期に戻しておかないと次、拡大・縮小する際におかしくなる
        currentScale = 1.0
        //maxScaleもいったん初期化学
        //2回目以降の拡大、縮小時中途半端なサイズが最大サイズになってしまう
        maxScale = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            locationIntialTouch = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            //移動量を計算し、自身のviewの座標を更新する
            frame = frame.offsetBy(dx: location.x - locationIntialTouch.x, dy: location.y - locationIntialTouch.y)
            judgeViewFrame()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            //移動量を計算し、自身のviewの座標を更新する
            frame = frame.offsetBy(dx: location.x - locationIntialTouch.x, dy: location.y - locationIntialTouch.y)
            judgeViewFrame()
        }
    }

    //移動時画面からはみ出していないか判定する
    @objc
    private func judgeViewFrame() {
        //はみ出していないか判定する
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
    }
    
}
