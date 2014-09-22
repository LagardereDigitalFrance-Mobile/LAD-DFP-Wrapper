//
//  DetailViewController.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 18/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "BannerViewController.h"

#import "Constants.h"
#import "GeolocManager.h"

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

@interface BannerViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation BannerViewController

#pragma mark DFP LAD Implementation Step 1
@synthesize adBanner ;

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
#pragma mark DFP LAD Implementation Step 2
    if (adBanner != nil)
    {
        adBanner.delegate = nil;
        [adBanner release];adBanner = nil;
    }
    
    [super dealloc];
}

#pragma mark - Initialization Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    
    return self;
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
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];

#pragma mark DFP LAD Implementation Step 3
    [self displayBannerAd]; // DFP Ad - Try to display banner ad
}

#pragma mark DFP LAD Implementation Step 4

#pragma mark - LAD DFP Methods

- (void)displayBannerAd
{
    @try
    {
        if (adBanner != nil)
        {
            adBanner.delegate = nil;
            [adBanner release]; adBanner = nil;
        }
        
        LAAdTags *bannerTags = nil;
        
        // Other initialization are possible see LAAdsTag.h
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) //case iPhone
        {
            bannerTags = [[LAAdTags alloc] initWithTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID"]
                                          AndRetinaTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID_Retina"]
                                         andiPhone5Tag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID_Retina"]];
        }
        else
        {
            bannerTags = [[LAAdTags alloc] initWithPortraitTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID_Portrait"]
                                               AndLandscapeTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID_Landscape"]
                                          AndRetinaPortraitTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID_Portrait_Retina"]
                                         AndRetinaLandscapeTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID_Landscape_Retina"]];
        }
        
        // Referencement de la page web correspondant a ce contenu mobile
        [bannerTags setWebContentUrlRef:@"http://_PUT_YOUR_CONTENT_WEB_URL"];
        
        /*************************************************************************************************************************************/
        // Cas simple d;affichage banniere sans params additionnel
        /*************************************************************************************************************************************/
        
        //LABannerView *tmp = [[LABannerView alloc] initWithContainerViewController:self AndAdTags:bannerTags];
        
        /*************************************************************************************************************************************/
        // Cas avec autorisation géolocalisation
        /*************************************************************************************************************************************/
        
        /*LABannerView *tmp = [[LABannerView alloc] initWithContainerViewController:self AndAdTags:bannerTags AndAdditionalParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"25", @"Age",
                              @"Blue,Green,Red", @"Color",nil] enableLocation:YES];
         
         [bannerTags release];
         [self setAdBanner:tmp];
         
         adBanner.delegate = self;
         [tmp release];
         
         [adBanner displayBannerAdOnView:self.view];
         */
        
        /**********************************************************************************************************************************/
        // Cas avec Passage Parametere additionel
        /*************************************************************************************************************************************/
        
        LABannerView *tmp = [[LABannerView alloc] initWithContainerViewController:self AndAdTags:bannerTags AndAdditionalParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                                     @"25", @"Age",
                                                                                                                                     @"Blue,Green,Red", @"Color",nil] enableLocation:NO];
        [bannerTags release];
        [self setAdBanner:tmp];
        
        adBanner.delegate = self;
        [tmp release];

        CLLocation * location = [[CLLocation alloc] initWithLatitude:48.853 longitude:2.35];
        
        [adBanner displayBannerAdOnView:self.view withLocation:location];
        [location release];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"\n\n\n!!! BannerViewController : DisplayBannerAd raise an exception => name : %@ | reason : %@ !!! \n\n",[exception name],[exception reason]);
    }
}

#pragma mark -LABannerViewDelegate Methods

- (void)needUpdateViewLayoutWithAdIsDisplay:(BOOL)adIsDisplay forBannerView:(LABannerView *)theBanner
{
    DLog(@"=> IsDisplay: %i | TRUE : %i",adIsDisplay,TRUE);
    
    if (adIsDisplay == TRUE)
    {
        // Banner advert is display need update content view
    }
    else
    {
        // Banner advert is hidden need update content view
    }    
}

#pragma mark - Rotation Methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
#pragma mark DFP LAD Implementation  Step 5
    [self displayBannerAd]; // DFP Ad - Try to display banner ad
}

/********************************************************** ONLY FOR CODE SAMPLE ***************************************************************/

#pragma mark - Show error Log

- (void)showError:(GADRequestError*)anError
{
    DLog(@"=> showError");
    
    [YRDropdownView showDropdownInView:self.view
                                 title:@"Error"
                                detail:[anError localizedDescription]
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES
                             hideAfter:8];
}

@end
