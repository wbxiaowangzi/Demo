//
//  SmartBigImageView.swift
//  Demo
//
//  Created by WangBo on 2025/4/15.
//  Copyright © 2025 wangbo. All rights reserved.
//

import UIKit
import ImageIO

class SmartBigImageView: UIScrollView, UIScrollViewDelegate {
    
    private let contentContainer = UIView()
    private let previewImageView = UIImageView()
    private var tiledView: TiledView?
    private var imageURL: URL
    private var hasSwitchedToTiled = false
    
    init(frame: CGRect, imageURL: URL) {
        self.imageURL = imageURL
        super.init(frame: frame)
        setupScrollView()
        loadPreview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScrollView() {
        delegate = self
        minimumZoomScale = 1.0
        maximumZoomScale = 5.0
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bouncesZoom = true
        
        addSubview(contentContainer)

        previewImageView.contentMode = .scaleAspectFit
        contentContainer.addSubview(previewImageView)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
    }

    private func loadPreview(maxPixel: CGFloat = UIScreen.main.bounds.width) {
        DispatchQueue.global(qos: .userInitiated).async {
            let options: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: maxPixel,
                kCGImageSourceCreateThumbnailWithTransform: true
            ]
            guard let source = CGImageSourceCreateWithURL(self.imageURL as CFURL, nil),
                  let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
                return
            }
            let image = UIImage(cgImage: cgImage)
            DispatchQueue.main.async {
                self.previewImageView.image = image
                self.previewImageView.frame = CGRect(origin: .zero, size: image.size)
                self.contentContainer.frame = self.previewImageView.frame
                self.contentSize = image.size
                self.setZoomScale(self.minimumZoomScale, animated: false)
            }
        }
    }

    @objc private func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self)
        if zoomScale != minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let zoomRect = zoomRectForScale(scale: maximumZoomScale, center: point)
            zoom(to: zoomRect, animated: true)
        }
    }

    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(width: bounds.size.width / scale,
                          height: bounds.size.height / scale)
        let origin = CGPoint(x: center.x - size.width / 2,
                             y: center.y - size.height / 2)
        return CGRect(origin: origin, size: size)
    }

    // MARK: - ScrollView Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentContainer
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if zoomScale > 2.5 && !hasSwitchedToTiled {
            switchToTiledView()
        }
    }

    // MARK: - 分块大图切换
    private func switchToTiledView() {
        guard tiledView == nil else { return }
        
        let tiled = TiledView(frame: contentContainer.bounds, imageURL: imageURL)
        contentContainer.insertSubview(tiled, aboveSubview: previewImageView)
        self.tiledView = tiled
        self.hasSwitchedToTiled = true
    }
}
