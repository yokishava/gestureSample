//
//  ViewController.swift
//  practiceGesture
//
//  Created by 吉川昂広 on 2018/05/12.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 画像の拡大率
    private var currentScale:CGFloat = 1.0
    private var maxScale: CGFloat!
    private var scaleArray: [CGFloat] = []
    private var specifiedMaxScale = false
    
    //var imageView: UIImageView!
    var imageView: RenderImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "wallpaper358.jpg")
        imageView = RenderImageView(image: image)
        self.view.addSubview(imageView)
//        imageView = UIImageView(image: image)
//        //imageView.image = UIImage(named: "wallpaper358.jpg")
//        //imageView.contentMode = .scaleAspectFit
//        imageView.frame.origin.x = 70
//        imageView.frame.origin.y = 200
//        imageView.frame.size = CGSize(width: 200, height: 200)
//        print(imageView.frame.maxX)
//        print(imageView.frame.maxY)
//        self.view.addSubview(imageView)
//        
//        imageView.isUserInteractionEnabled = true
        
        // imageViewにジェスチャーレコグナイザを設定する(ピンチ)
        //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
        //imageView.addGestureRecognizer(pinchGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func pinchAction(sender: UIPinchGestureRecognizer) {
        // imageViewを拡大縮小する
        // ピンチ中の拡大率は0.3〜2.5倍、指を離した時の拡大率は0.5〜2.0倍とする
        switch sender.state {
        case .began, .changed:
            // senderのscaleは、指を動かしていない状態が1.0となる
            // 現在の拡大率に、(scaleから1を引いたもの) / 10(補正率)を加算する
            currentScale = currentScale + (sender.scale - 1) / 10
            // 拡大率が基準から外れる場合は、補正する
            if currentScale < 0.3 {
                currentScale = 0.3
            } else if currentScale > 2.5 {
                currentScale = 2.5
            }
            
            // 計算後の拡大率で、imageViewを拡大縮小する
            imageView.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            
            scaleArray.append(currentScale)
            
            print("***************************************")
            print(currentScale)
            print(imageView.frame.origin.x)
            print(imageView.frame.maxX)
            //print(imageView.frame.maxY)
            //print(imageView.frame.origin.y)
            print("***************************************")
            
            //
            if imageView.frame.origin.x < 0 || imageView.frame.origin.y < 0 || imageView.frame.maxX > UIScreen.main.bounds.width || imageView.frame.maxY > UIScreen.main.bounds.height {

                if !specifiedMaxScale {
                    // -1にすべきか-2にすべきか。。。
                    maxScale = scaleArray[self.scaleArray.count - 1]
                    specifiedMaxScale = true
                }
                
                print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                print(maxScale)
                print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                
                imageView.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)

            }
        default:
            if currentScale < 0.5 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: nil)
            }
            
            //scaleArray.removeAll()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

