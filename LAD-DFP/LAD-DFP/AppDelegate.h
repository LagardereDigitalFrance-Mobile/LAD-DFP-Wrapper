//
//  AppDelegate.h
//  LAD-DFP
//
//  Created by DUPUY Yann on 18/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GADInterstitialDelegate>

/*** PROPERTIES ***/

@property (strong, nonatomic)   UIWindow *  window;

@property (strong, nonatomic)   UINavigationController  *navigationController;

@property (strong, nonatomic)   UISplitViewController   *splitViewController;
// LA-DFP
@property (retain, nonatomic)   LAInterstitial          *intersAdController;

/***  METHODS  ***/

/// Ask to display an Interstiail Ad on an UIViewController
- (void)displaySplashInterstitialOnViewController:(UIViewController*)aViewController;

@end
