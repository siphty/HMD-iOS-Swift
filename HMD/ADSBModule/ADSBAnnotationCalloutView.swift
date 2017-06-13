//
//  ADSBAnnotationCalloutView.swift
//  HMD
//
//  Created by Yi JIANG on 13/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import NVActivityIndicatorView

class ADSBAnnotationCalloutView: UIView {
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        if #available(iOS 9.0, *) {
            label.font = .preferredFont(forTextStyle: .callout)
        } else {
            // Fallback on earlier versions
            label.font = .preferredFont(forTextStyle: .caption2)
        }
        
        return label
    }()
    private var loadingIndicator: NVActivityIndicatorView!
    
    init(annotation: MKShape) {
        super.init()
        configure()
        updateContents(for: annotation)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }
    /// Update callout contents
    
    private func updateContents(for annotation: MKShape) {
        titleLabel.text = annotation.title ?? ""
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-5)
        }
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: .ballBeat, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), padding: 0)
        contentView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
        
        
    }
}
