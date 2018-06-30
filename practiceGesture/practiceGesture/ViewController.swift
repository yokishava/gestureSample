//
//  ViewController.swift
//  practiceGesture
//
//  Created by 吉川昂広 on 2018/05/12.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var lockMode: Bool = false
    
    var childView: RenderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = RenderView()
        self.view.addSubview(view)
        
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 10
        button.setTitle("ロック変更", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)

        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
    }
    
    //初期表示時上から順に呼び出される
    //LayoutSubviewsがorientaionを変更した時に呼び出される
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        print(self.view.frame.width)
        print(self.view.frame.height)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubview")
        print(self.view.frame.width)
        print(self.view.frame.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        print(self.view.frame.width)
        print(self.view.frame.height)
        //RenderViewにorientaitionが変更したことを通知
        currentFrameNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        print(self.view.frame.width)
        print(self.view.frame.height)
    }
    
    override var shouldAutorotate: Bool {
        return lockMode
    }
    
    /*
     shouldAutorotateがfalseの状態で
     portraitからlandscapeに変更
     この時、
     ・上のメソッドは呼び出されない
     ・viewのwidthとheightも入れ替わらない
     
     shouldAutorotateがfalseの状態で
     portraitからlandscapeに変更
     変更後、sholdAutorotateをtrueにする
     この時
     ・上のメソッドは呼び出されない
     ・viewのwidthとheightも入れ替わらない
     */
    
    @objc func tappedButton() {
        if lockMode {
            lockMode = false
            print(lockMode)
        } else {
            lockMode = true
            print(lockMode)
        }
        print(self.view.frame.width)
        print(self.view.frame.height)
    }
    
    private func currentFrameNotification() {
        if self.view.frame.width > self.view.frame.height {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateOrientation"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "landscape"), object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

