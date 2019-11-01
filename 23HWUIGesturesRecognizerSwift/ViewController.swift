//
//  ViewController.swift
//  23HWUIGesturesRecognizerSwift
//
//  Created by Сергей on 30.10.2019.
//  Copyright © 2019 Sergei. All rights reserved.
//

//Ученик✅
//
//1. Добавьте квадратную картинку на вьюху вашего контроллера
//2. Если хотите, можете сделать ее анимированной
//
//Студент
//
//3. По тачу анимационно передвигайте картинку с ее позиции в позицию тача
//4. Если я вдруг делаю тач во время анимации, то картинка должна двигаться в новую точку без рывка (как будто она едет себе и все)
//
//Мастер
//
//5. Если я делаю свайп вправо, то давайте картинке анимацию поворота по часовой стрелке на 360 градусов
//6. То же самое для свайпа влево, только анимация должна быть против часовой (не забудьте остановить предыдущее кручение)
//7. По двойному тапу двух пальцев останавливайте анимацию
//
//Супермен 
//
//8. Добавьте возможность зумить и отдалять картинку используя пинч
//9. Добавьте возможность поворачивать картинку используя ротейшн


import UIKit
import AVFoundation

class ViewController: UIViewController , CAAnimationDelegate, UIGestureRecognizerDelegate {

    let four: CGFloat = 4.0
    
    let drum = UIImageView(image: UIImage(named: "drum.png"))
    let leading = UIImageView(image: UIImage(named: "leading.png"))
    
    var testViewScale: CGFloat = 0.0
    var testViewRotation: CGFloat = 0.0
    
    var player: AVAudioPlayer?
    
    var tapGesture: UITapGestureRecognizer!
    var rightSwipeGesture: UISwipeGestureRecognizer!
    var leftSwipeGesture: UISwipeGestureRecognizer!
    var doubleTapDoubleTouch: UITapGestureRecognizer!
    var pinchGesture: UIPinchGestureRecognizer!
    var rotationGesture: UIRotationGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(cgColor: CGColor.init(srgbRed: 153.0, green: 255.0, blue: 153.0, alpha: 1.0))
        let color = UIColor.rgb(red: 173, green: 255, blue: 47)
        self.view.backgroundColor = color
        //1 task
        self.drum.frame = CGRect(x: self.view.bounds.midX - 150.0, y: self.view.bounds.midY - 150.0, width: 300.0, height: 300.0)
        self.view.addSubview(self.drum)
        
        self.leading.frame = CGRect(x: 600.0, y: 300.0, width: 200.0, height: 500.0)
        self.view.addSubview(self.leading)
        
        //2 task
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(tapGesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //3 task
        self.rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(swipeGesture:)))
        self.rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(self.rightSwipeGesture)
        
        self.leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(swipeGesture:)))
        self.leftSwipeGesture.direction = .left
        self.view.addGestureRecognizer(self.leftSwipeGesture)
        
        
        self.doubleTapDoubleTouch = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapDoubleTouch(doubleTapDoubleTouch:)))
        self.doubleTapDoubleTouch.numberOfTouchesRequired = 2
        self.doubleTapDoubleTouch.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(self.doubleTapDoubleTouch)
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinchGesture:)))
        self.pinchGesture.delegate = self
        self.view.addGestureRecognizer(self.pinchGesture)
        
        self.rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(rotationGesture:)))
        self.rotationGesture.delegate = self
        self.view.addGestureRecognizer(self.rotationGesture)
        
    }

    //MARK: Functions for gesture recognazer
    
    
    
    //MARK: Function doubleTapDoubleTouch
    @objc private func handleDoubleTapDoubleTouch(doubleTapDoubleTouch: UITapGestureRecognizer) {
        print("handleDoubleTapDoubleTouch(doubleTapDoubleTouch: UITapGestureRecognizer)")
        
        self.drum.layer.removeAnimation(forKey: "clockwiceRotation")
        self.drum.layer.removeAnimation(forKey: "notClockwiceRotation")
        self.player?.stop()
        
    }
    
    //MARK: Function Tap Gesture
    @objc private func handleTap(tapGesture: UITapGestureRecognizer) {

        print("handleTap")
        
        let pointTap = tapGesture.location(in: self.view)
        
        let restrictedArea = self.leading.frame.insetBy(dx: -(self.drum.bounds.width / 4), dy: -(self.drum.bounds.height / 4))
    
        if !restrictedArea.contains(pointTap) {
            
            UIView.animate(withDuration: 2.3) {
                
                self.drum.center = pointTap
                
            }
        }
    }
    
    //MARK: Function Swipe Gesture
    
    @objc private func handleRightSwipe(swipeGesture: UISwipeGestureRecognizer) {
        
        print("handleRightSwipe(swipeGesture:")
        
        self.player = self.initializePlayerWith(resource: "baraban_1995_hq", type: "mp3")
        self.player?.numberOfLoops = Int.max
        self.player?.play()
        
        self.drum.layer.removeAnimation(forKey: "notClockwiceRotation")
    
            UIView.animate(withDuration: 3.0, delay: 0, options: .beginFromCurrentState, animations: {
                
                let animation = self.makeAnimateion(duration: 3.0, clockwise: true, repeating: true)
                animation.fromValue =
                self.drum.layer.add(animation, forKey: "clockwiceRotation")
                
            }) { (finished) in
                ///
            }
    }
    
    @objc private func handleLeftSwipe(swipeGesture: UISwipeGestureRecognizer) {
        
        print("handleRightSwipe(swipeGesture:")
        
        self.player?.stop()
        self.player = self.initializePlayerWith(resource: "bankrupt-2000-full-hq", type: "mp3")
        self.player?.play()
        
        self.drum.layer.removeAnimation(forKey: "clockwiceRotation")
        
            UIView.animate(withDuration: 3.0, delay: 0, options: .beginFromCurrentState, animations: {
                
                let animation = self.makeAnimateion(duration: 3.0, clockwise: false, repeating: false)
                self.drum.layer.add(animation, forKey: "notClockwiceRotation")
                
            }) { (finished) in
                ///
            }
    }
    
    //MARK: Function Pinch
    
    @objc private func handlePinchGesture(pinchGesture: UIPinchGestureRecognizer) {
    
    print("handlePinchGesture(pinchGesture:")
        
        
        if (pinchGesture.state == .began) {
        
            self.testViewScale = 1.0
        
            self.player = self.initializePlayerWith(resource: "rotationAndPinchDrum", type: "mp3")
            self.player?.play()
            
        }
       
        self.testViewScale = 1.0 + pinchGesture.scale - self.testViewScale

        let currentTransform = self.drum.transform
        
        let newScale = currentTransform.scaledBy(x: self.testViewScale, y: self.testViewScale)
        
        self.drum.transform = newScale
        
        self.testViewScale = pinchGesture.scale
        
    
    }
    
    
    //MARK: Function Rotation
        
    @objc private func handleRotationGesture(rotationGesture: UIRotationGestureRecognizer) {
    
        if rotationGesture.state == .began {
            
            self.testViewRotation = 0.0
            
        }
        
        self.testViewRotation = rotationGesture.rotation - self.testViewRotation
        
        let currentTransform = self.drum.transform
        let newTransform = currentTransform.rotated(by: self.testViewRotation)
        
        self.drum.transform = newTransform
        
        self.testViewRotation = rotationGesture.rotation
        
        
    }
    
    //MARK: Help Function
    
    private func makeAnimateion(duration: CFTimeInterval, clockwise: Bool, repeating: Bool) -> CABasicAnimation {
        print("makeAnimateion(clockwise: Bool, repeating: Bool)")
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.toValue = clockwise ? Double.pi * 2 : Double.pi * -2
        rotation.repeatCount = repeating ? Float.greatestFiniteMagnitude : 1
    
        return rotation
    }
    
    private func initializePlayerWith(resource: String, type: String) -> AVAudioPlayer? {
        
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            return nil
        }
        
        return try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        
        
    }
    
    //REMARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true

    }
    
}

