//
//  UIPageControl.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 03/05/21.
//

import UIKit
import ImageSlideshow

extension UIPageControl: PageIndicatorView {

    public static func withSlideshowColors() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "22578E")
        pageControl.pageIndicatorTintColor = UIColor(hexString: "22578E").withAlphaComponent(0.4)
        return pageControl
    }
}
