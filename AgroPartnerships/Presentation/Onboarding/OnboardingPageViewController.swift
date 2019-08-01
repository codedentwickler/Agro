//
//  OnboardingPageViewController.swift
//  SaveFunds
//
//  Created by Kanyinsola on 19/09/2018.
//  Copyright © 2018 Crevance Savers. All rights reserved.
//

import Foundation

class OnboardingPageViewController: UIPageViewController, UIScrollViewDelegate {
    
    func getStepOne() -> OnboardingStepOneViewController {
        return storyboard!.instantiateViewController(withIdentifier: "OnboardingStepOneViewController") as! OnboardingStepOneViewController
    }
    
    func getStepTwo() -> OnboardingStepTwoViewController {
        return storyboard!.instantiateViewController(withIdentifier: "OnboardingStepTwoViewController") as! OnboardingStepTwoViewController
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        dataSource = self
        
        setViewControllers([getStepOne()], direction: .forward, animated: false, completion: nil)
    }
}

extension OnboardingPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: OnboardingStepTwoViewController.self)  {
            return getStepOne()
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: OnboardingStepOneViewController.self)  {
            return getStepTwo()
        } else {
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

