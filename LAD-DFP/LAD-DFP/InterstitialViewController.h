//
//  InterstitialViewController.h
//  LAD-DFP
//
//  Created by DUPUY Yann on 19/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark DFP LAD Implementation Step 1
@class LAInterstitial;

@interface InterstitialViewController : UIViewController
{
#pragma mark DFP LAD Implementation Step 2
    LAInterstitial *interstitial;
}

#pragma mark DFP LAD Implementation Step 3
@property (nonatomic, strong)   LAInterstitial         *interstitial;

@end
