//
//  ADSBCalloutView.swift
//  HMD
//
//  Created by Yi JIANG on 13/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//
import UIKit
import MapKit
import SnapKit

open class ADSBCalloutView: UIView {
    
    /// Shape of pointer at the bottom of the callout bubble
    ///
    /// - rounded: Circular, rounded pointer.
    /// - straight: Straight lines for pointer. The angle is measured in radians, must be greater than 0 and less than `.pi` / 2. Using `.pi / 4` yields nice 45 degree angles.
    
    enum BubblePointerType {
        case rounded
        case straight(angle: CGFloat)
    }
    
    /// Shape of pointer at bottom of the callout bubble, pointing at annotation view.
    
    private let bubblePointerType = BubblePointerType.rounded
    
    /// Insets for rounding of callout bubble's corners
    ///
    /// The "bottom" is amount of rounding for pointer at the bottom of the callout
    
    private let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// Shape layer for callout bubble
    
    private let bubbleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.black.cgColor
        layer.lineWidth = 0.5
        return layer
    }()
    
    /// Content view for annotation callout view
    ///
    /// This establishes the constraints between the `contentView` and the `CalloutView`,
    /// leaving enough padding for the chrome of the callout bubble.
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }
    
    /// Configure the view.
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(inset.left / 2.0)
            make.top.equalTo(inset.top / 2.0)
            make.bottom.equalTo(-inset.bottom - inset.right / 2.0)
            make.right.equalTo(-inset.right / 2.0)
            make.width.greaterThanOrEqualTo(inset.left + inset.right)
            make.height.greaterThanOrEqualTo(inset.top + inset.bottom)
        }
        
        addBackgroundButton(to: contentView)
        
        layer.insertSublayer(bubbleLayer, at: 0)
    }
    
    // if the view is resized, update the path for the callout bubble
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        updatePath()
    }
    
    // Override hitTest to detect taps within our callout bubble
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let contentViewPoint = convert(point, to: contentView)
        return contentView.hitTest(contentViewPoint, with: event)
    }
    
    /// Update `UIBezierPath` for callout bubble
    ///
    /// The setting of the bubblePointerType dictates whether the pointer at the bottom of the
    /// bubble has straight lines or whether it has rounded corners.
    
    private func updatePath() {
        let path = UIBezierPath()
        
        var point: CGPoint
        
        var controlPoint: CGPoint
        
        point = CGPoint(x: bounds.size.width - inset.right, y: bounds.size.height - inset.bottom)
        path.move(to: point)
        
        switch bubblePointerType {
        case .rounded:
            // lower right
            point = CGPoint(x: bounds.size.width / 2.0 + inset.bottom, y: bounds.size.height - inset.bottom)
            path.addLine(to: point)
            
            // right side of arrow
            
            controlPoint = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height - inset.bottom)
            point = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
            path.addQuadCurve(to: point, controlPoint: controlPoint)
            
            // left of pointer
            
            controlPoint = CGPoint(x: point.x, y: bounds.size.height - inset.bottom)
            point = CGPoint(x: point.x - inset.bottom, y: controlPoint.y)
            path.addQuadCurve(to: point, controlPoint: controlPoint)
        case .straight(let angle):
            // lower right
            point = CGPoint(x: bounds.size.width / 2.0 + tan(angle) * inset.bottom, y: bounds.size.height - inset.bottom)
            path.addLine(to: point)
            
            // right side of arrow
            
            point = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
            path.addLine(to: point)
            
            // left of pointer
            
            point = CGPoint(x: bounds.size.width / 2.0 - tan(angle) * inset.bottom, y: bounds.size.height - inset.bottom)
            path.addLine(to: point)
        }
        
        // bottom left
        
        point.x = inset.left
        path.addLine(to: point)
        
        // lower left corner
        
        controlPoint = CGPoint(x: 0, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: 0, y: controlPoint.y - inset.left)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // left
        
        point.y = inset.top
        path.addLine(to: point)
        
        // top left corner
        
        controlPoint = CGPoint.zero
        point = CGPoint(x: inset.left, y: 0)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // top
        
        point = CGPoint(x: bounds.size.width - inset.left, y: 0)
        path.addLine(to: point)
        
        // top right corner
        
        controlPoint = CGPoint(x: bounds.size.width, y: 0)
        point = CGPoint(x: bounds.size.width, y: inset.top)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // right
        
        point = CGPoint(x: bounds.size.width, y: bounds.size.height - inset.bottom - inset.right)
        path.addLine(to: point)
        
        // lower right corner
        
        controlPoint = CGPoint(x:bounds.size.width, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: bounds.size.width - inset.right, y: bounds.size.height - inset.bottom)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        path.close()
        
        bubbleLayer.path = path.cgPath
    }
    
    /// Add this `CalloutView` to an annotation view (i.e. show the callout on the map above the pin)
    ///
    /// - Parameter annotationView: The annotation to which this callout is being added.
    
    func add(to annotationView: MKAnnotationView) {
        annotationView.addSubview(self)
        
        // constraints for this callout with respect to its superview
        snp.makeConstraints { (make) in
            make.bottom.equalTo(annotationView.snp.top).offset(annotationView.calloutOffset.y)
            make.centerX.equalTo(annotationView).offset(annotationView.calloutOffset.x)
        }
    }
}
extension ADSBCalloutView {
    
    /// Add background button to callout
    ///
    /// This adds a button, the same size as the callout's `contentView`, to the `contentView`.
    /// The purpose of this is two-fold: First, it provides an easy method, `didTouchUpInCallout`,
    /// that you can `override` in order to detect taps on the callout. Second, by adding this
    /// button (rather than just adding a tap gesture or the like), it ensures that when you tap
    /// on the button, that it won't simultaneously register as a deselecting of the annotation,
    /// thereby dismissing the callout.
    ///
    /// This serves a similar functional purpose as `_MKSmallCalloutPassthroughButton` in the
    /// default system callout.
    ///
    /// - Parameter view: The view to which we're adding this button.
    
    fileprivate func addBackgroundButton(to view: UIView) {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        button.addTarget(self, action: #selector(didTouchUpInCallout(_:)), for: .touchUpInside)
    }
    
    /// Callout tapped.
    ///
    /// If you want to detect a tap on the callout, override this method. By default, this method does nothing.
    ///
    /// - Parameter sender: The actual hidden button that was tapped, not the callout, itself.
    
    func didTouchUpInCallout(_ sender: Any) {
        // this is intentionally blank
    }
}
