//
//  DetailViewController.h
//  LAD-DFP
//
//  Created by DUPUY Yann on 18/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark DFP LAD Implementation - Step 1

#import "LABannerView.h"

@class  GADRequest;

@interface BannerViewController : UIViewController <UISplitViewControllerDelegate, LABannerViewDelegate>
{
#pragma mark DFP LAD Implementation - Step 2
    LABannerView *adBanner;
}

#pragma mark DFP LAD Implementation - Step 3
@property (nonatomic, strong)               LABannerView       *adBanner;

@end
