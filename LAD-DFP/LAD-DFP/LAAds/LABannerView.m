//
//  LABannerView.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 21/12/12.
//  Updated by DUPUY Yann on 17/07/14.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "LABannerView.h"

#pragma mark  DFP Step 1

#import "GeolocManager.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "GADAdMobExtras.h"
#import "LAAdTags.h"

#import <AdSupport/ASIdentifierManager.h>

//---------------- DEBUG MACRO ------------------

#pragma mark - Debug configuration

//#define DEBUG_ENABLE //Activate Debug log only in this file

/**
 *  - Activate Debug Log for all file  if  "DEBUG_VERBOSE" define in GCC PREPROCESSOR MACRO (build setting)
 *  - Activate Debug only in a file if variable DEBUG_ENABLE  define in the file
 */

#if (defined DEBUG_ENABLE || defined DEBUG_VERBOSE)
#   define DLog(fmt, ...) NSLog((@"\n\n%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

//----------------------------------------------

@interface LABannerView ()
{
    NSDictionary    *adParams;
}

@property (nonatomic) BOOL enableLocation;

- (void)configureBannerForView:(UIView *)aView;

@end

@implementation LABannerView

#ifdef DFPSAMPLE
// NOTE : just for test remove in production code snippet
@synthesize parentViewController;
#endif

#pragma mark  DFP Step 2
@synthesize adBanner = adBanner_;
@synthesize adTagsID;
@synthesize containerViewController;
@synthesize delegate;
@synthesize request;

//----------------------------------------------------------------
// ----------------------- PRIVATE METHODS -----------------------
//----------------------------------------------------------------

#pragma  mark - Ad display configuration Methods (Private)

- (void)prepareBannerAdDisplay
{
    if (adParams == nil)
    {
        return;
    }
    
    UIView *aView = [adParams objectForKey:@"targetView"];
    CLLocation *provideLocation = [adParams objectForKey:@"provideLocation"];
    
    if (aView != nil && containerViewController != nil && self.delegate != nil)
    {
        [self configureBannerForView:aView];
        
        if (adBanner_ != nil )
        {
            //DLog(@" => Ask ad display withTagID : %@ \n and withAdditionalParameters : %@",adBanner_.adUnitID, request.additionalParameters);
            
            // Configure GPS Coord if provide or location enable
            if(provideLocation != nil)
            {
                [request setLocationWithLatitude:provideLocation.coordinate.latitude longitude:provideLocation.coordinate.longitude accuracy:100];
            }
            else if(_enableLocation)
            {
                CLLocation * location = [[GeolocManager sharedInstance] getLastLocation];
                [request setLocationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude accuracy:100];
            }
            
            // Content URL Passing Configuration
            if (self.adTagsID.webContentUrlRef != nil && self.adTagsID.webContentUrlRef.length > 0)
            {
                self.request.contentURL = self.adTagsID.webContentUrlRef;
            }
            
            // For "Place Media" integration add user ID in keyword
            if (NSClassFromString(@"ASIdentifierManager"))
            {
                if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] == TRUE)
                {
                    [self.request addKeyword:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
                }
            }
            
            [adBanner_ loadRequest:request];
        }
    }
}

//----------------------------------------------------------------
// ----------------------- PUBLIC METHODS ------------------------
//----------------------------------------------------------------

#pragma mark - Memory Methods

- (void)dealloc
{
#pragma mark  DFP Step 3
    
    [self cancelAdDisplayRequest];
    
    if (adParams != nil)
    {
        [adParams release]; adParams = nil;
    }
    
    if (adBanner_ != nil)
    {
        adBanner_.adSizeDelegate = nil;
        adBanner_.delegate = nil;
        [adBanner_ removeFromSuperview];
        [adBanner_ release];
    }
    
    if (adTagsID != nil)
    {
        [adTagsID  release]; adTagsID = nil; 
    }

    if (request != nil)
    {
        [request release];
        request = nil;
    }
    
    if (containerViewController != nil)
    {
        containerViewController = nil;
    }
    
    if (delegate != nil)
    {
        self.delegate = nil;
    }
    
#ifdef DFPSAMPLE
//NOTE : just for test remove in production code snippet
    if (parentViewController != nil)
    {
        [parentViewController release]; parentViewController = nil;
    }
#endif
    
    [super dealloc];
}

#pragma mark - Initialization Methods

- (id)initWithContainerViewController:(UIViewController*)aContainerViewController AndAdTags:(LAAdTags*)aTagsList
{
    self = [self initWithContainerViewController:aContainerViewController AndAdTags:aTagsList AndAdditionalParameters:nil];
    
    if (self)
    {
    }
    
    return self;
}

- (id)initWithContainerViewController:(UIViewController*)aContainerViewController AndAdTags:(LAAdTags*)aTagsList enableLocation:(BOOL)enable
{
    self = [self initWithContainerViewController:aContainerViewController AndAdTags:aTagsList];
    
    if(self)
    {
        self.enableLocation = enable;
    }
    
    return self;
}

// New instanciation implementation in order to add some extra info when requesting some ads banner
- (id)initWithContainerViewController:(UIViewController*)aContainerViewController AndAdTags:(LAAdTags*)aTagsList AndAdditionalParameters:(NSDictionary *)extrasParams
{
    self = [super init];
    
    if (self)
    {
        self.request = [self createRequest];
        
        // Define Extra params for keywords as example
        GADAdMobExtras *extras = [[[GADAdMobExtras alloc] init] autorelease];
        extras.additionalParameters = [NSMutableDictionary dictionaryWithDictionary:extrasParams];
        
        //====================================================================================================
        /*
         Paramètre destiné aux mineurs : Children's Online Privacy Protection Act (COPPA) 
         doc DFP : https://developers.google.com/mobile-ads-sdk/docs/admob/additional-controls#ios-coppa
         
         Si vous définissez tag_for_child_directed_treatment sur 1, vous indiquez que vous souhaitez voir votre contenu traité comme étant destiné aux mineurs conformément aux dispositions de la loi COPPA.
         Si vous définissez tag_for_child_directed_treatment sur 0, vous indiquez que vous ne souhaitez pas que votre contenu soit traité comme étant destiné aux enfants conformément aux dispositions de la loi COPPA.
         Si vous ne définissez pas tag_for_child_directed_treatment, les demandes d'annonces n'indiquent pas comment traiter votre contenu par rapport à la loi COPPA.
         */
        
        //[extras setValue:@"1" forKey:@"tag_for_child_directed_treatment"];
        
        //====================================================================================================
        
        [request registerAdNetworkExtras:extras];
        
        [self setAdTagsID:aTagsList];
        [self setContainerViewController:aContainerViewController];
    }
    
    return self;
}

- (id)initWithContainerViewController:(UIViewController*)aContainerViewController AndAdTags:(LAAdTags*)aTagsList AndAdditionalParameters:(NSDictionary *)extrasParams enableLocation:(BOOL)enable
{
    self = [self initWithContainerViewController:aContainerViewController AndAdTags:aTagsList AndAdditionalParameters:extrasParams];
    
    if (self)
    {
        self.enableLocation = enable;
    }
    
    return self;
}

#pragma mark  DFP Step 6 - Banner Ad Display Methods

- (void)displayBannerAdOnView:(UIView*)aView
{
    if (aView == nil) // bad case params can't be nil
    {
        return;
    }
    
    NSDictionary *adParameters = [[NSDictionary alloc] initWithObjectsAndKeys:aView,@"targetView", nil];
    adParams = adParameters;
    [self performSelector:@selector(prepareBannerAdDisplay) withObject:nil afterDelay:0.3];
}

- (void)displayBannerAdOnView:(UIView*)aView withLocation:(CLLocation *)location
{
    if (aView == nil || location == nil) // bad case params can't be nil
    {
        return;
    }
    
    NSDictionary *adParameters = [[NSDictionary alloc] initWithObjectsAndKeys:aView,@"targetView",location,@"provideLocation", nil];
    adParams = adParameters;
    [self performSelector:@selector(prepareBannerAdDisplay) withObject:nil afterDelay:0.3];
}

- (void)configureBannerForView:(UIView *)aView
{
    DLog(@" => displayBannerAdOnView: %@",[aView description]);
    
    CGSize bannerSize = CGSizeZero;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) // iPAD CASE
    {
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            bannerSize = CGSizeMake(768, 90);
        }
        else
        {
            bannerSize = CGSizeMake(1024, 90);
        }
    }
    else
    {
        bannerSize = CGSizeFromGADAdSize(kGADAdSizeBanner);
    }
    
    // Define Ad Space Area
    if (adBanner_ != nil)
    {
        adBanner_.adSizeDelegate = nil;
        adBanner_.delegate = nil;
        [adBanner_ removeFromSuperview];
        [adBanner_ release]; adBanner_ = nil;
    }
    
    CGPoint origin = CGPointMake(0.0, aView.frame.size.height - bannerSize.height);
    adBanner_ = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    adBanner_.delegate = self;
    
    adBanner_.alpha = 0.0;
    
    [aView addSubview:adBanner_];
    
    // Configure Multiple Ad Size
    NSMutableArray *validSizes = [NSMutableArray array];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) // iPAD CASE
    {
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            GADAdSize size1 = GADAdSizeFromCGSize(CGSizeMake(768, 90)); // Banner Portrait normal
            [validSizes addObject:[NSValue valueWithBytes:&size1 objCType:@encode(GADAdSize)]];
        }
        else
        {
            GADAdSize size3 = GADAdSizeFromCGSize(CGSizeMake(1024, 90)); // Banner Landscape normal
            [validSizes addObject:[NSValue valueWithBytes:&size3 objCType:@encode(GADAdSize)]];
        }
    }
    else // iPhone CASE
    {
        GADAdSize size1 = GADAdSizeFromCGSize(CGSizeMake(320, 50)); // banner
        [validSizes addObject:[NSValue valueWithBytes:&size1 objCType:@encode(GADAdSize)]];
    }
    
    adBanner_.validAdSizes = validSizes;
    adBanner_.adSizeDelegate = self;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    adBanner_.rootViewController = containerViewController;
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        if ([adTagsID isiPhone5] == TRUE)
        {
            adBanner_.adUnitID = adTagsID.iPhone5PortraitTag;
        }
        else if ([adTagsID isRetina] == TRUE)
        {
            adBanner_.adUnitID = adTagsID.retinaPortraitTag;
        }
        else
        {
            adBanner_.adUnitID = adTagsID.defaultPortraitTag;
        }
    }
    else
    {
        if ([adTagsID isiPhone5] == TRUE)
        {
            adBanner_.adUnitID = adTagsID.iPhone5LandscapeTag;
        }
        else if ([adTagsID isRetina] == TRUE)
        {
            adBanner_.adUnitID = adTagsID.retinaLandscapeTag;
        }
        else
        {
            adBanner_.adUnitID = adTagsID.defaultLandscapeTag;
        }
    }
}

- (void)cancelAdDisplayRequest
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(prepareBannerAdDisplay) object:nil];
}

#pragma mark - GADRequest generation

// Here we're creating a simple GADRequest and whitelisting the application
// for test ads. You should request test ads during development to avoid
// generating invalid impressions and clicks.
- (GADRequest *)createRequest
{
    GADRequest * uriRequest = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    
#if TARGET_IPHONE_SIMULATOR
    uriRequest.testDevices =
    [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
#else
    uriRequest.testDevices =
    [NSArray arrayWithObjects:
     // TODO: Add your device/simulator test identifiers here. They are
     // printed to the console when the app is launched.
     nil];
#endif
    
    return uriRequest;
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    DLog(@" => Received ad successfully");
    
    //Update banner alpha
    [UIView beginAnimations:@"showAd" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [adBanner_ setAlpha:1.0];
    [UIView commitAnimations];
    
    // Make other transformations on content view
    if ((delegate != nil) && [delegate respondsToSelector:@selector(needUpdateViewLayoutWithAdIsDisplay:forBannerView:)])
    {
        [delegate needUpdateViewLayoutWithAdIsDisplay:TRUE forBannerView:self];
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    DLog(@" => Failed to receive ad with error: %@", [error localizedFailureReason]);
    
    //Update banner alpha
    [UIView beginAnimations:@"hideAd" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [adBanner_ setAlpha:0.0];
    [UIView commitAnimations];
    
    // Make other transformations on content view
    if ((delegate != nil) && [delegate respondsToSelector:@selector(needUpdateViewLayoutWithAdIsDisplay:forBannerView:)])
    {
        [delegate needUpdateViewLayoutWithAdIsDisplay:FALSE forBannerView:self];
    }
    
#ifdef DFPSAMPLE

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
    if ([parentViewController respondsToSelector:@selector(showError:)])// !!! NOTE : just for test remove in production code snippet !!!
    {
        [parentViewController showError:error];
    }
#pragma clang diagnostic pop
    
#endif
}

#pragma mark Click-Time Lifecycle Notifications

// Sent just before presenting the user a full screen view, such as a browser,
// in response to clicking on an ad.  Use this opportunity to stop animations,
// time sensitive interactions, etc.
//
// Normally the user looks at the ad, dismisses it, and control returns to your
// application by calling adViewDidDismissScreen:.  However if the user hits the
// Home button or clicks on an App Store link your application will end.  On iOS
// 4.0+ the next method called will be applicationWillResignActive: of your
// UIViewController (UIApplicationWillResignActiveNotification).  Immediately
// after that adViewWillLeaveApplication: is called.
- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    DLog(@" => adViewWillPresentScreen");
}

// Sent just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(GADBannerView *)adView
{
    DLog(@"=> adViewWillDismissScreen");
    
    //Update banner alpha
    [UIView beginAnimations:@"hideAd" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [adBanner_ setAlpha:0.0];
    [UIView commitAnimations];
    
    // Make other transformations on content view
    if ((delegate != nil) && [delegate respondsToSelector:@selector(needUpdateViewLayoutWithAdIsDisplay:forBannerView:)])
    {
        [delegate needUpdateViewLayoutWithAdIsDisplay:FALSE forBannerView:self];
    }
}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    DLog(@" => adViewDidDismissScreen");
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    DLog(@" => adViewWillLeaveApplication");
    //Update banner alpha
    [UIView beginAnimations:@"hideAd" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [adBanner_ setAlpha:0.0];
    [UIView commitAnimations];
    
    // Make other transformations on content view
    if ((delegate != nil) && [delegate respondsToSelector:@selector(needUpdateViewLayoutWithAdIsDisplay:forBannerView:)])
    {
        [delegate needUpdateViewLayoutWithAdIsDisplay:FALSE forBannerView:self];
    }
}

#pragma  mark - GADAdSizeDelegate Method

- (void)adView:(DFPBannerView *)view willChangeAdSizeTo:(GADAdSize)size
{
    DLog(@"=> willChangeAdSizeTo : %@\n\n",NSStringFromCGSize(size.size));
}

@end
