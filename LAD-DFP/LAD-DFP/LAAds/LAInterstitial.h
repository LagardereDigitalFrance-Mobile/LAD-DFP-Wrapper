//
//  LAInterstitial.h
//  LAD-DFP
//
//  Created by DUPUY Yann on 21/12/12.
//  Updated by DUPUY Yann on 17/07/14.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPInterstitial.h"
#import "GeolocManager.h"


@class LAAdTags;

@interface LAInterstitial : UIView <GADInterstitialDelegate>
{
    DFPInterstitial     *interstitial_;
    UIViewController    *containerViewController_;
    LAAdTags            *adTagsID;
    BOOL                interIsOnScreen;
}

/************* ATTRIBUTES *************/

@property (nonatomic, strong)   DFPInterstitial         *interstitial;
@property (nonatomic, strong)   GADRequest              *request;
@property (nonatomic, weak)     UIViewController        *containerViewController;
@property (nonatomic, strong)   LAAdTags                *adTagsID;
@property (nonatomic, strong)   UIImageView             *splashImage;
@property (nonatomic, assign)   BOOL                    interIsOnScreen;

/************** Methods **************/

#pragma mark - Initialization Methods

/// Init Interstitial Ad for iPhone (Only for one interface Orientation )
- (id)initWithAndParentContainer:(UIViewController*)aParentViewController AndAdTagID:(LAAdTags*)aTagsID;

- (id)initWithAndParentContainer:(UIViewController*)aParentViewController AndAdTagID:(LAAdTags*)aTagsID enableLocation:(BOOL)enable;

- (id)initWithAndParentContainer:(UIViewController*)aParentViewController AndAdTagID:(LAAdTags*)aTagsID AndOptionalParameter:(NSDictionary*)optionalParams;


// Init Interstitial Ad for splash on app Startup
- (id)initForSplashAdWithAdtagID:(LAAdTags*)aTagsID;

- (id)initForSplashAdWithAdtagID:(LAAdTags*)aTagsID enableLocation:(BOOL)enable;

- (void)displaySplashAdOnViewController: (UIViewController*)currentViewController AndWithSplashImg:(BOOL)activateSplash;


#pragma mark - Ad display Methods

/// Make an Interstitial displayon a normal viewControler
- (void)displayInterAd;

- (void)displayInterAdWithLocation:(CLLocation *)location;

@end
