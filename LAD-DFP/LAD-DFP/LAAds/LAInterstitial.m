//
//  LAInterstitial.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 21/12/12.
//  Updated by DUPUY Yann on 17/07/14.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "LAInterstitial.h"

#pragma mark  DFP Step 1
#import "DFPInterstitial.h"
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

@interface LAInterstitial ()
@property (nonatomic) BOOL enableLocation;

- (GADRequest *)createRequest;
- (void)configureIntertitial;

@end

@implementation LAInterstitial

@synthesize interstitial = interstitial_;
@synthesize containerViewController = containerViewController_;
@synthesize adTagsID;
@synthesize splashImage;
@synthesize interIsOnScreen;

#pragma mark - Memory Methods

- (void)dealloc
{
#pragma mark  DFP Step 4
    
    if (adTagsID!= nil)
    {
        [adTagsID release]; adTagsID = nil;
    }
    
    if (containerViewController_ != nil)
    {
        containerViewController_ = nil;
    }
    
    if (interstitial_ != nil)
    {
        interstitial_.delegate = nil;
        [interstitial_ release];interstitial_ = nil;
    }
    
    if (splashImage != nil)
    {
        [splashImage removeFromSuperview];
        [splashImage release]; splashImage = nil;
    }
    
    [super dealloc];
}

#pragma mark - Initialization Methods

/// Init Interstitial Ad for iPhone (Only for one interface Orientation )
- (id)initWithAndParentContainer:(UIViewController*)aParentViewController AndAdTagID:(LAAdTags*)aTagsID
{
    self = [super init];
    
    if (self)
    {
#pragma mark  DFP Step 2
        
        interstitial_ = [[DFPInterstitial alloc] init];
        [interstitial_ setDelegate:self];
        
        // DFP - Prepare Inter Ad
        [self setContainerViewController:aParentViewController];
        [self setAdTagsID:aTagsID];
    }
    
    return self;
}

/// Init Interstitial Ad for iPhone (Only for one interface Orientation )
- (id)initWithAndParentContainer:(UIViewController*)aParentViewController AndAdTagID:(LAAdTags*)aTags enableLocation:(BOOL)enable
{
    self = [self initWithAndParentContainer:aParentViewController AndAdTagID:aTags];
    
    if (self)
    {
        // DFP - Prepare Inter Ad
        _enableLocation = enable;
    }
    
    return self;
}

// Init Interstitial Ad for splash on app Startup
- (id)initForSplashAdWithAdtagID:(LAAdTags*)aTagsID
{
    self = [super init];
    
    if (self)
    {
        interstitial_ = [[DFPInterstitial alloc] init];
        [interstitial_ setDelegate:self];
        
        [self setAdTagsID:aTagsID];
        self.interIsOnScreen = NO;
    }
    
    return self;
}

- (id)initForSplashAdWithAdtagID:(LAAdTags*)aTagsID enableLocation:(BOOL)enable
{
    self = [self initForSplashAdWithAdtagID:aTagsID];
    
    if (self)
    {
        _enableLocation = enable;
    }
    
    return self;
}

#pragma mark - Ad Request Method

- (GADRequest *)createRequest
{
    GADRequest * request = [[GADRequest alloc] init];
    
    return [request autorelease];
}

- (void)configureIntertitial
{
    // Configure good Tag unit depending on device and orientation
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        if ([adTagsID isiPhone5] == TRUE)
        {
            interstitial_.adUnitID = adTagsID.iPhone5PortraitTag;
        }
        else if ([adTagsID isRetina] == TRUE)
        {
            interstitial_.adUnitID = adTagsID.retinaPortraitTag;
        }
        else
        {
            interstitial_.adUnitID = adTagsID.defaultPortraitTag;
        }
    }
    else
    {
        if ([adTagsID isiPhone5] == TRUE)
        {
            interstitial_.adUnitID = adTagsID.iPhone5LandscapeTag;
        }
        else if ([adTagsID isRetina] == TRUE)
        {
            interstitial_.adUnitID = adTagsID.retinaLandscapeTag;
        }
        else
        {
            interstitial_.adUnitID = adTagsID.defaultLandscapeTag;
        }
    }
}

#pragma mark - Ad display Methods

/// Make an Interstitial display on a normal viewControler
- (void)displayInterAd
{
    DLog(@" => displayInterAd");
    
    [self configureIntertitial];
    
    // make ad request
    GADRequest * request = [self createRequest];
    
    if(_enableLocation)
    {
        CLLocation * location = [[GeolocManager sharedInstance] getLastLocation];
        [request setLocationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude accuracy:100];
    }
    
    // Content URL Passing Configuration
    if (self.adTagsID.webContentUrlRef != nil && self.adTagsID.webContentUrlRef.length > 0)
    {
        request.contentURL = self.adTagsID.webContentUrlRef;
    }
    
    // For "Place Media" integration add user ID in keyword
    if (NSClassFromString(@"ASIdentifierManager"))
    {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] == TRUE)
        {
            [request addKeyword:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
        }
    }
    
    [interstitial_ loadRequest:request];
}

- (void)displayInterAdWithLocation:(CLLocation *)location
{
    DLog(@" => displayInterAd");
    
    [self configureIntertitial];
    
    // make ad request
    GADRequest * request = [self createRequest];
    
    if(location)
    {
        [request setLocationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude accuracy:100];
    }
    
    // Content URL Passing Configuration
    if (self.adTagsID.webContentUrlRef != nil && self.adTagsID.webContentUrlRef.length > 0)
    {
        request.contentURL = self.adTagsID.webContentUrlRef;
    }
    
    // For "Place Media" integration add user ID in keyword
    if (NSClassFromString(@"ASIdentifierManager"))
    {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] == TRUE)
        {
            [request addKeyword:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
        }
    }
    
    [interstitial_ loadRequest:request];
}


/// Init Interstitial Ad for iPhone (Only for one interface Orientation )
- (id)initWithAndParentContainer:(UIViewController*)aParentViewController AndAdTagID:(LAAdTags*)aTagsID AndOptionalParameter:(NSDictionary*)optionalParams
{
    self = [super init];
    
    if (self)
    {
        interstitial_ = [[DFPInterstitial alloc] init];
        [interstitial_ setDelegate:self];
        
        // Define Extra params for keywords as example
        GADAdMobExtras *extras = [[[GADAdMobExtras alloc] init] autorelease];
        extras.additionalParameters = [NSMutableDictionary dictionaryWithDictionary:optionalParams];
        
        // DFP - Prepare Inter Ad
        self.request = [self createRequest];
        
        [self.request registerAdNetworkExtras:extras];
        
        [self setContainerViewController:aParentViewController];
        [self setAdTagsID:aTagsID];
    }
    
    return self;
}

// implementation v2.0

- (void)displaySplashAdOnViewController: (UIViewController*)currentViewController AndWithSplashImg:(BOOL)activateSplash
{
    DLog(@" => displaySplashAdOnViewController\n\n");
    
    if (interstitial_ != nil) // clean up any old DFPInterstitial Object
    {
        interstitial_.delegate = nil;
        [interstitial_ release]; interstitial_=nil;
    }
    
    //Prepare ad Space
    interstitial_ = [[DFPInterstitial alloc] init];
    [interstitial_ setDelegate:self];
    
    [self setContainerViewController:currentViewController];
    
    // Configure good Tag unit depending on device and orientation
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        if ([adTagsID isiPhone5] == TRUE)
        {
            interstitial_.adUnitID = adTagsID.iPhone5PortraitTag;
        }
        else if ([adTagsID isRetina] == TRUE)
        {
            interstitial_.adUnitID = adTagsID.retinaPortraitTag;
        }
        else
        {
            interstitial_.adUnitID = adTagsID.defaultPortraitTag;
        }
    }
    else
    {
        if ([adTagsID isiPhone5] == TRUE)
        {
            interstitial_.adUnitID = adTagsID.iPhone5LandscapeTag;
        }
        else if ([adTagsID isRetina] == TRUE)
        {
            interstitial_.adUnitID = adTagsID.retinaLandscapeTag;
        }
        else
        {
            interstitial_.adUnitID = adTagsID.defaultLandscapeTag;
        }
    }
    
    DLog(@" => interstitial_.adUnitID  Selected:%@\n\n\n",interstitial_.adUnitID);
    
    
    // make ad request
    GADRequest * request = [self createRequest];
    
    // Content URL Passing Configuration
    if (self.adTagsID.webContentUrlRef != nil && self.adTagsID.webContentUrlRef.length > 0)
    {
        request.contentURL = self.adTagsID.webContentUrlRef;
    }
    
    // For "Place Media" integration add user ID in keyword
    if (NSClassFromString(@"ASIdentifierManager"))
    {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] == TRUE)
        {
            [request addKeyword:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
        }
    }
    
    [interstitial_ loadRequest:request];
    
    if (activateSplash== TRUE)
    {
        [self displaySplashImage]; // Change app rootview controller to splash view controller which manage DFP Interstitial and Default image display
    }
}

#pragma mark - Splash Image Methods

- (void)displaySplashImage
{
    DLog(@" => displaySplashImage\n\n");
    
    UIImage *image = nil;
    
    //Define Default Splashscreen image to display
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([adTagsID isiPhone5])
        {
            image = [UIImage imageNamed:@"Default-568h"];
        }
        else
        {
            image = [UIImage imageNamed:@"Default"];
        }
    }
    else
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            image = [UIImage imageNamed:@"Default-Landscape"];
        }
        else
        {
            image = [UIImage imageNamed:@"Default-Portrait"];
        }
        
        if (nil == image)
        {
            image = [UIImage imageNamed:@"Default"];
        }
    }
    
    UIView *rootView = nil;
    
    if ([containerViewController_ isKindOfClass:[UIViewController class]])
    {
        rootView = self.containerViewController.view;
    }
    else
    {
        rootView = self.containerViewController.navigationController.navigationBar;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self setSplashImage:imageView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGRect frame = imageView.frame;
        frame.origin.y = -20;
        imageView.frame = frame;
    }
    
    [rootView addSubview:splashImage];
    [imageView release];
}

- (void)removeSplashImage
{
    DLog(@" => removeSplashImage\n\n");
    
    if (splashImage != nil)// assure Splash Image is remove from containerViewController
    {
        [splashImage removeFromSuperview];
        [splashImage release]; splashImage = nil;
    }
}

#pragma mark - Interstitial Delegate Methods

- (void)interstitialDidReceiveAd:(DFPInterstitial *)interstitial
{
    DLog(@" => interstitialDidReceiveAd");
     self.interIsOnScreen = YES;
    [interstitial_ presentFromRootViewController:containerViewController_];
}

- (void)interstitial:(DFPInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    DLog(@"=> didFailToReceiveAdWithError");
    NSLog(@"error %@",error);
    
#ifdef DFPSAMPLE
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
    if ([containerViewController_ respondsToSelector:@selector(showError:)]) //NOTE : just for test remove in production code snippet
    {
        [containerViewController_ showError:error];
#pragma clang diagnostic pop
    }
    
#endif
}

- (void)interstitialWillPresentScreen:(DFPInterstitial *)interstitial
{
    DLog(@" => interstitialWillPresentScreen");
     self.interIsOnScreen = TRUE;
}

- (void)interstitialDidDismissScreen:(DFPInterstitial *)interstitial
{
    DLog(@" => interstitialDidDismissScreen");
     self.interIsOnScreen = FALSE;
}

- (void)interstitialWillDismissScreen:(DFPInterstitial *)interstitial
{
    DLog(@" => interstitialWillDismissScreen");
}

- (void)interstitialWillLeaveApplication:(DFPInterstitial *)interstitial
{
    DLog(@" => interstitialWillLeaveApplication");
     self.interIsOnScreen = FALSE;
}

@end
