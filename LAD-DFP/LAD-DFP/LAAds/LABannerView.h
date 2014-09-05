//
//  LABannerView.h
//  LAD-DFP
//
//  Created by DUPUY Yann on 21/12/12.
//  Updated by DUPUY Yann on 17/07/14.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import <UIKit/UIKit.h>

//DFP
#import "GADBannerViewDelegate.h"
#import "GADAdSizeDelegate.h"
#import "DFPBannerView.h"
#import <CoreLocation/CoreLocation.h>

@class LABannerView;

@protocol LABannerViewDelegate <NSObject>

@optional

/// Inform container UIViewController need adapt his layout accoding ad display state
- (void)needUpdateViewLayoutWithAdIsDisplay:(BOOL)adIsDisplay forBannerView:(LABannerView *)theBanner;

@end

@class GADRequest;
@class LAAdTags;

@interface LABannerView : NSObject <GADBannerViewDelegate,GADAdSizeDelegate>
{
    // DFP
    DFPBannerView               *adBanner_;
    LAAdTags                    *adTagsID;
    UIViewController            *containerViewController;
    id<LABannerViewDelegate>    delegate;
    GADRequest                  *request;
    
#ifdef DFPSAMPLE
// NOTE : just for test remove in production code snippet
    UIViewController            *parentViewController;
#endif
}

/************* ATTRIBUTES *************/

// DFP
@property (nonatomic, strong)               DFPBannerView               *adBanner;
@property (nonatomic, strong)               LAAdTags                    *adTagsID;
@property (nonatomic, weak)                 UIViewController            *containerViewController;
@property (nonatomic, weak)                 id<LABannerViewDelegate>	delegate;
@property (nonatomic, strong)               GADRequest                  *request;

#ifdef DFPSAMPLE
// NOTE : just for test remove in production code snippet
@property (nonatomic, strong)               UIViewController            *parentViewController;
#endif

/************** METHODS **************/

/// Initialization for banner ad space
- (id)initWithContainerViewController:(UIViewController*)aContainerViewController AndAdTags:(LAAdTags*)aTagsList;

- (id)initWithContainerViewController:(UIViewController*)aContainerViewController AndAdTags:(LAAdTags*)aTagsList enableLocation:(BOOL)enable;

- (id)initWithContainerViewController:(UIViewController*)aContainerViewController AndAdTags:(LAAdTags*)aTagsList AndAdditionalParameters:(NSDictionary *)extrasParams;

- (id)initWithContainerViewController:(UIViewController*)aContainerViewController AndAdTags:(LAAdTags*)aTagsList AndAdditionalParameters:(NSDictionary *)extrasParams enableLocation:(BOOL)enable;

/// Ask to display banner on area aView;
- (void)displayBannerAdOnView:(UIView*)aView;

- (void)displayBannerAdOnView:(UIView*)aView withLocation:(CLLocation *)location;

/// Make ad request on DFP platform
- (GADRequest *)createRequest;

@end
