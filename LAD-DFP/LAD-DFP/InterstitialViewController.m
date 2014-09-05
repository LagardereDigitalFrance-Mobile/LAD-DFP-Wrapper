//
//  InterstitialViewController.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 19/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "InterstitialViewController.h"

#import "Constants.h"
#import "LADFPAdsHeader.h"

#import "YRDropdownView.h"

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

@interface InterstitialViewController ()

@end

@implementation InterstitialViewController

#pragma mark DFP LAD Implementation  Step 1
@synthesize interstitial;

#pragma mark - LAD-DFP Methods

#pragma mark DFP LAD Implementation  Step 2

- (void)displayAnInterstitialAd
{
    @try
    {
        // DFP - Prepare Inter Ad
        LAAdTags *interAdTags = nil;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) //case iPhone
        {
            interAdTags = [[LAAdTags alloc] initWithTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID"]
                                           AndRetinaTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Retina"]
                                          andiPhone5Tag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_iPhone5"]];
        }
        else
        {
            interAdTags = [[LAAdTags alloc] initWithPortraitTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Portrait"]
                                                AndLandscapeTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Landscape"]
                                           AndRetinaPortraitTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Portrait_Retina"]
                                          AndRetinaLandscapeTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Landscape_Retina"]];
        }
        
        if (interstitial != nil)
        {
            [interstitial release]; interstitial = nil;
        }
        
        //intertitial avec position GPS

        CLLocation * location = [[GeolocManager sharedInstance] getLastLocation];
        
        LAInterstitial *tmp = [[LAInterstitial alloc] initWithAndParentContainer:self AndAdTagID:interAdTags];
        [self setInterstitial:tmp];
        [tmp release];
        [interAdTags release];
        [interstitial displayInterAdWithLocation:location];
    }
    @catch (NSException *exception)
    {
        NSLog(@"\n\n\n!!! InterstitalViewController : displayAnInterstitialAd raise an exception => name : %@ | reason : %@ !!!\n\n\n",[exception name],[exception reason]);
    }
}

#pragma mark - View Life Cycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#pragma mark DFP LAD Implementation Step 3
    [self displayAnInterstitialAd]; // DFP Ad - try to display an Interstitial Ad
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Rotation Methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
#pragma mark DFP LAD Implementation Step 4
    [self displayAnInterstitialAd]; // DFP Ad - try to display an Interstitial Ad
}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
#pragma mark DFP LAD Implementation Step 5
    if (interstitial != nil)
    {
        [interstitial release];interstitial = nil;
    }
    
    [super dealloc];
}

/**************************** ONLY FOR CODE SAMPLE ****************************/

#pragma mark - Show error Log

- (void)showError:(GADRequestError*)anError
{
    DLog(@" => showError");
    
    [YRDropdownView showDropdownInView:self.view
                                 title:@"Error"
                                detail:[anError localizedDescription]
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES
                             hideAfter:8];
}

@end
