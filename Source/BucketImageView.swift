//
//  BucketImageView.swift
//  iRecordView
//
//  Created by Devlomi on 8/8/19.
//  Copyright © 2019 Devlomi. All rights reserved.
//

import UIKit


protocol AnimationFinishedDelegate {
    func animationFinished()
}

class BucketImageView: UIImageView, CAAnimationDelegate {

    var smallMicImage: UIImage! {
        didSet {
            micLayer.contents = smallMicImage.cgImage
        }
    }

    private var bucketLidLayer = CALayer()
    private var bucketBodyLayer = CALayer()
    private var micLayer = CALayer()
    //this layer will contain bucketLidLayer + bucketBodyLayer
    private var bucketContainerLayer = CALayer()

    private let animationNameKey = "animation_name"
    private let micUpAnimationName = "mic_up_animation"
    private let micDownAnimationName = "mic_down_animation"
    private let bucketUpAnimationName = "bucket_up_animation"
    private let bucketDownAnimationName = "bucket_drive_down_animation"
    private let micAlphaAnimationName = "mic_alpha_animation"

    //the height of the Mic that should go up to
    private let micUpAnimationHeight: CGFloat = 150;
    private let micYOffsetFromBase = 7;


    private var micMidY, micOriginY: CGFloat!
    private var bucketY: CGFloat!

    var animationDelegate: AnimationFinishedDelegate?


    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    //animate small Mic Infinite Alpha
    func animateAlpha() {
        micLayer.isHidden = false
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")

        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1.0
        alphaAnimation.repeatCount = .infinity
        alphaAnimation.autoreverses = true
        alphaAnimation.duration = 0.8
        alphaAnimation.speed = 0.8

        micLayer.add(alphaAnimation, forKey: micAlphaAnimationName)
    }


    private func setup() {

        smallMicImage = UIImage.fromPod("mic_red")


        let bucketLidImage = UIImage.fromPod("bucket_lid")
        let bucketBodyImage = UIImage.fromPod("bucket_body")

        bucketLidLayer.anchorPoint = CGPoint(x: 0.15, y: 1.56);
        bucketBodyLayer.anchorPoint = CGPoint.zero

        bucketLidLayer.contents = bucketLidImage.cgImage
        bucketLidLayer.frame = CGRect(x: 0, y: 0, width: bucketLidImage.size.width, height: bucketLidImage.size.height)

        bucketBodyLayer.contents = bucketBodyImage.cgImage
        bucketBodyLayer.frame = CGRect(x: 0, y: bucketLidImage.size.height + 2, width: bucketBodyImage.size.width, height: bucketBodyImage.size.height)


        micLayer.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        micLayer.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
        micLayer.contents = smallMicImage.cgImage

        //align bucket below the mic to be invisible
        bucketContainerLayer.frame = micLayer.frame.offsetBy(dx: 5, dy: 200)

        bucketContainerLayer.addSublayer(bucketLidLayer)
        bucketContainerLayer.addSublayer(bucketBodyLayer)


        bucketContainerLayer.zPosition = 98
        micLayer.zPosition = 97
        layer.addSublayer(micLayer)
        layer.addSublayer(bucketContainerLayer)


    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //start animation 'driveUp'
    func animateBucketAndMic() {
        micLayer.removeAnimation(forKey: micAlphaAnimationName)
        micDriveUpAnimation()
    }


    func resetAnimations() {
        micLayer.removeAllAnimations()
        bucketContainerLayer.removeAllAnimations()
        bucketLidLayer.removeAllAnimations()
        bucketBodyLayer.removeAllAnimations()
        micLayer.isHidden = false
        bucketContainerLayer.isHidden = true
    }

    //open bucket (move bucket lid)
    private func openBucket() {
        let animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        let animation = CAKeyframeAnimation()
        animation.duration = 0.4
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.keyPath = "transform.rotation.z"
        animation.values = [DegreesToRadians(degrees: 0), DegreesToRadians(degrees: -60)]
        animation.timingFunctions = [animationTimingFunction, animationTimingFunction]


        bucketLidLayer.add(animation, forKey: "open")

    }


    //close bucket (move bucket lid)
    private func closeBucket() {
        
        let animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        let animation = CAKeyframeAnimation()
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.keyPath = "transform.rotation.z"
        animation.values = [DegreesToRadians(degrees: -60), DegreesToRadians(degrees: 0)]
        animation.timingFunctions = [animationTimingFunction, animationTimingFunction]
        animation.duration = 0.4


        bucketLidLayer.add(animation, forKey: "close")

    }


    private func DegreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        if micMidY == nil {
            micMidY = micLayer.frame.midY
        }

        if micOriginY == nil {
            micOriginY = micLayer.frame.origin.y
        }


        if bucketY == nil {
            bucketY = bucketContainerLayer.frame.origin.y
        }
    }

    private func micDriveUpAnimation() {

        let moveAnimation = CABasicAnimation(keyPath: "position.y")
        moveAnimation.fromValue = [micLayer.position.y]
        moveAnimation.toValue = [micLayer.frame.midY - micUpAnimationHeight];
        moveAnimation.isRemovedOnCompletion = false;
        moveAnimation.fillMode = CAMediaTimingFillMode.forwards
        moveAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)


        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform")
        rotateAnimation.values = [0.0, CFloat.pi, CGFloat.pi * 1.5, CGFloat.pi * 2.0]
        rotateAnimation.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
        rotateAnimation.isRemovedOnCompletion = false;
        rotateAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotateAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]


        let animGroup = CAAnimationGroup()
        animGroup.delegate = self

        animGroup.setValue(micUpAnimationName, forKey: animationNameKey)
        animGroup.animations = [moveAnimation, rotateAnimation]
        animGroup.duration = 0.6;
        animGroup.isRemovedOnCompletion = false;
        animGroup.fillMode = CAMediaTimingFillMode.forwards
        micLayer.add(animGroup, forKey: micUpAnimationName)
    }

    private func micDriveDownAnimation() {
        let moveAnimation = CABasicAnimation(keyPath: "position.y")
        moveAnimation.delegate = self
        moveAnimation.setValue(micDownAnimationName, forKey: animationNameKey)
        moveAnimation.toValue = [micLayer.position.y]
        moveAnimation.duration = 0.6
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = CAMediaTimingFillMode.forwards

        moveAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        micLayer.add(moveAnimation, forKey: micDownAnimationName)
    }


    private func bucketDriveDownAnimation() {
        let moveAnimation = CABasicAnimation(keyPath: "position.y")
        moveAnimation.delegate = self
        moveAnimation.setValue(bucketDownAnimationName, forKey: animationNameKey)
        moveAnimation.toValue = [micMidY + 100]
        moveAnimation.duration = 0.6
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = CAMediaTimingFillMode.forwards
        moveAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        moveAnimation.beginTime = CACurrentMediaTime() + 0.4
        bucketContainerLayer.add(moveAnimation, forKey: bucketDownAnimationName)
    }

    private func bucketDriveUpAnimation() {
        let moveAnimation = CABasicAnimation(keyPath: "position.y")
        moveAnimation.delegate = self
        moveAnimation.setValue(bucketUpAnimationName, forKey: animationNameKey)
        moveAnimation.fromValue = [bucketContainerLayer.position.y]
        moveAnimation.toValue = [micMidY]
        moveAnimation.duration = 0.6
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = CAMediaTimingFillMode.forwards
        moveAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        bucketContainerLayer.add(moveAnimation, forKey: bucketUpAnimationName)

    }

    func animationDidStart(_ anim: CAAnimation) {
        if let animationName = anim.value(forKey: animationNameKey) as? String {
            if animationName == micDownAnimationName {
                bucketDriveUpAnimation()
            } else if animationName == bucketUpAnimationName {
                bucketContainerLayer.isHidden = false
                openBucket()
            }
        }
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !flag {
            return
        }

        if let animationName = anim.value(forKey: animationNameKey) as? String {
            if animationName == micUpAnimationName {
                micDriveDownAnimation()
            } else if animationName == micDownAnimationName {
                micLayer.isHidden = true
                closeBucket()
                self.bucketDriveDownAnimation()
            } else if animationName == bucketDownAnimationName {
                bucketContainerLayer.isHidden = true
                animationDelegate?.animationFinished()
            }
        }
    }

}
