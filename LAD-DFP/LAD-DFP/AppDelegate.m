//
//  AppDelegate.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 18/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "BannerViewController.h"
#import "LADFPAdsHeader.h"
#import "Constants.h"

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

#pragma mark DFP LAD Implementation - Step 1
//DFP Ads
#import <AdSupport/ASIdentifierManager.h>

@implementation AppDelegate

@synthesize intersAdController;

#pragma mark - Memory Methods

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [_splitViewController release];
    [intersAdController release];
    
    [super dealloc];
}

#pragma mark - Application Life Cycle Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    
    [self checkIftagInit];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController_iPhone" bundle:nil] autorelease];
        self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    }
    else
    {
        MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController_iPad" bundle:nil] autorelease];
        self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    }
    
    self.window.rootViewController = self.navigationController;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    
    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)])
    {
        [[UINavigationBar appearance] setTranslucent:FALSE];
    }
    
    [self.window makeKeyAndVisible];
    
#pragma mark DFP LAD Implementation - Step 2
    // Print IDFA (from AdSupport Framework) for iOS 6 and UDID for iOS < 6.
    if (NSClassFromString(@"ASIdentifierManager"))
    {
        NSLog(@"GoogleAdMobAdsSDK ID for testing: %@" ,
              [[[ASIdentifierManager sharedManager]
                advertisingIdentifier] UUIDString]);
    }
    
    DLog(@" => GoogleAdMobAdsSDK is %@\n\n",[GADRequest sdkVersion]); // Print DFP SDK version
    
    [self performSelector:@selector(displaySplashInterstitialOnViewController:) withObject:self.window.rootViewController afterDelay:1.0];

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
#pragma mark DFP LAD Implementation - Step 3 (dont forget to put it when the application is launched first time)
    [self performSelector:@selector(displaySplashInterstitialOnViewController:) withObject:self.window.rootViewController afterDelay:1.0];
    
#pragma mark DFP LAD Implementation - Step 5 (close any video)
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ApplicationDidEnterBackgroundAndNeedToCloseVideo" object:nil]];
}

//DFP Ad - Methods
#pragma mark - Ad SplashScreen Methods

- (void)displaySplashInterstitialOnViewController:(UIViewController*)aViewController
{
    @try
    {
        if (intersAdController != nil && intersAdController.splashImage != nil && intersAdController.splashImage.superview != nil)
        {
            // An ad is already display
            DLog(@" =>  An Ad is already display \n\n\n");
            [self performSelector:@selector(displaySplashInterstitialOnViewController:)withObject:aViewController afterDelay:0.3];
            return;
        }
        
        @try
        {
            LAAdTags *splashInterTags;
            
            // Define Advertisements tags for multitargeting
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) // iPhone case
            {
                splashInterTags = [[LAAdTags alloc] initWithTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID"]
                                                   AndRetinaTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Retina"]
                                                  andiPhone5Tag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_iPhone5"]];
                
                
            }
            else // iPad Case
            {
                splashInterTags = [[LAAdTags alloc] initWithPortraitTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Portrait"]
                                                        AndLandscapeTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Landscape"]
                                                   AndRetinaPortraitTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Portrait_Retina"]
                                                  AndRetinaLandscapeTag:[[NSUserDefaults standardUserDefaults] objectForKey:@"kInterstitialAdUnitID_Landscape_Retina"]];
            }
            
            if (intersAdController != nil)
            {
                [intersAdController release]; intersAdController = nil;
            }
            
            LAInterstitial *tmp = [[LAInterstitial alloc] initForSplashAdWithAdtagID:splashInterTags];
            [self setIntersAdController:tmp];
            [tmp release];
            
            DLog(@" => Ad display on viewController is : %@\n\n",[aViewController description]);
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                [intersAdController displaySplashAdOnViewController:aViewController AndWithSplashImg:FALSE];
            }
            else
            {
                [intersAdController displaySplashAdOnViewController:aViewController AndWithSplashImg:FALSE];
            }
            
            [splashInterTags release];
        }
        @catch (NSException *exception)
        {
            NSLog(@"\n\n\n!!! AppDelegate : displayInterAd raise an exception=> name : %@ | reason : %@ !!!\n\n\n",[exception name],[exception reason]);
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"\n\n\n!!! AppDelegate : displayInterAd raise an exception=> name : %@ | reason : %@ !!!\n\n\n",[exception name],[exception reason]);
    }
    @finally
    {
        return;
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    NSLog(@" => interstitialDidDismissScreen");
}

/******************************************************************************************************************/
/************************************************ ONLY FOR CODE SAMPLE ********************************************/
/******************************************************************************************************************/

#pragma mark - Data Management

- (void)checkIftagInit
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) // iPhone case
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID"] != nil)
        {
            // Tag Init is done
            return;
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:kBannerAdUnitID forKey:@"kBannerAdUnitID"];
            [[NSUserDefaults standardUserDefaults] setObject:kBannerAdUnitID_Retina forKey:@"kBannerAdUnitID_Retina"];
            
            [[NSUserDefaults standardUserDefaults] setObject:kInterstitialAdUnitID forKey:@"kInterstitialAdUnitID"];
            [[NSUserDefaults standardUserDefaults] setObject:kInterstitialAdUnitID_Retina forKey:@"kInterstitialAdUnitID_Retina"];
            [[NSUserDefaults standardUserDefaults] setObject:kInterstitialAdUnitID_iPhone5 forKey:@"kInterstitialAdUnitID_iPhone5"];
        }
    }
    else // iPad case
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kBannerAdUnitID_Portrait"] != nil)
        {
            // Tag Init is done
            return;
        }
        else
        {
            //Banner Tags
            [[NSUserDefaults standardUserDefaults] setObject:kBannerAdUnitID_Portrait forKey:@"kBannerAdUnitID_Portrait"];
            [[NSUserDefaults standardUserDefaults] setObject:kBannerAdUnitID_Landscape forKey:@"kBannerAdUnitID_Landscape"];
            
            [[NSUserDefaults standardUserDefaults] setObject:kBannerAdUnitID_Portrait_Retina forKey:@"kBannerAdUnitID_Portrait_Retina"];
            [[NSUserDefaults standardUserDefaults] setObject:kBannerAdUnitID_Landscape_Retina forKey:@"kBannerAdUnitID_Landscape_Retina"];
            
            //Interstitial Tags
            [[NSUserDefaults standardUserDefaults] setObject:kInterstitialAdUnitID_Portrait forKey:@"kInterstitialAdUnitID_Portrait"];
            [[NSUserDefaults standardUserDefaults] setObject:kInterstitialAdUnitID_Landscape forKey:@"kInterstitialAdUnitID_Landscape"];
            
            [[NSUserDefaults standardUserDefaults] setObject:kInterstitialAdUnitID_Portrait_Retina forKey:@"kInterstitialAdUnitID_Portrait_Retina"];
            [[NSUserDefaults standardUserDefaults] setObject:kInterstitialAdUnitID_Landscape_Retina forKey:@"kInterstitialAdUnitID_Landscape_Retina"];
        }        
    }
}

#pragma mark - OpenURL Methods

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([[url scheme] isEqual:@"dfplad"])
	{
		[self actionForOpenURLWith:[url absoluteString]];
        
		return TRUE;
	}
    
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([[url scheme] isEqual:@"dfplad"])
	{
        [self actionForOpenURLWith:[url absoluteString]];
		return TRUE;
	}
    
    return NO;
}

- (void)actionForOpenURLWith:(NSString*)anURL
{
    LAAdTags *tool = [[LAAdTags alloc] init];
    NSString *titleLbl = @"";
    NSString *msgLbl = @"";
    
    if ([anURL rangeOfString:@"/banner"].length >= 1) //case set Banner Ad Tag
    {
        NSString *tagValue = [anURL stringByReplacingOccurrencesOfString:@"dfplad://banner" withString:@""];
        
        if ([tool isRetina] == TRUE)
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kBannerAdUnitID_Retina"];
            titleLbl = @"Modification Tag Banner Retina";
            msgLbl = @"Le tag Banner Retina a été modifié";
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kBannerAdUnitID"];
            titleLbl = @"Modification Tag Banner";
            msgLbl = @"Le tag Banner a été modifié";
        }
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleLbl
                                                        message:msgLbl
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if ([anURL rangeOfString:@"/inter"].length >= 1)
    {
        NSString *tagValue = [anURL stringByReplacingOccurrencesOfString:@"dfplad://inter" withString:@""];
        
        if ([tool isiPhone5] == TRUE)
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kInterstitialAdUnitID_iPhone5"];
            titleLbl = @"Modification Tag Interstitiel iPhone 5";
            msgLbl = @"Le tag Interstitiel a été modifié iPhone 5";
        }
        else if ([tool isRetina] == TRUE)
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kInterstitialAdUnitID_retina"];
            titleLbl = @"Modification Tag Interstitiel Retina";
            msgLbl = @"Le tag Interstitiel Retina a été modifié";
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kInterstitialAdUnitID"];
            titleLbl = @"Modification Tag Interstitiel";
            msgLbl = @"Le tag Interstitiel a été modifié";
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleLbl
                                                        message:msgLbl
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if ([anURL rangeOfString:@"/portraitbanner"].length >= 1)
    {
        NSString *tagValue = [anURL stringByReplacingOccurrencesOfString:@"dfplad://portraitbanner" withString:@""];
        
        if ([tool isRetina] == TRUE)
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kBannerAdUnitID_Portrait_Retina"];
            titleLbl = @"Modification Tag Banner Portrait";
            msgLbl = @"Le tag Banner Portrait a été modifié";
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kBannerAdUnitID_Portrait"];
            titleLbl = @"Modification Tag Banner Portrait";
            msgLbl = @"Le tag Banner Portrait a été modifié";
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleLbl
                                                        message:msgLbl
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if ([anURL rangeOfString:@"/landscapebanner"].length >= 1)
    {
        NSString *tagValue = [anURL stringByReplacingOccurrencesOfString:@"dfplad://landscapebanner" withString:@""];
        
        if ([tool isRetina] == TRUE)
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kBannerAdUnitID_Landscape_Retina"];
            titleLbl = @"Modification Tag Banner Landscape Retina";
            msgLbl = @"Le tag Banner Landscape Retina a été modifié";
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kBannerAdUnitID_Landscape"];
            titleLbl = @"Modification Tag Banner Landscape";
            msgLbl = @"Le tag Banner Landscape a été modifié";
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleLbl
                                                        message:msgLbl
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if ([anURL rangeOfString:@"/portraitinter"].length >= 1)
    {
        NSString *tagValue = [anURL stringByReplacingOccurrencesOfString:@"dfplad://portraitinter" withString:@""];
        
        if ([tool isRetina] == TRUE)
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kInterstitialAdUnitID_Portrait_Retina"];
            titleLbl = @"Modification Tag Interstitiel Portrait Retina";;
            msgLbl = @"Le tag Interstitiel Portrait Retina a été modifié";
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kInterstitialAdUnitID_Portrait"];
            titleLbl = @"Modification Tag Interstitiel Portrait";
            msgLbl = @"Le tag Interstitiel Portrait a été modifié";
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleLbl
                                                        message:msgLbl
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if ([anURL rangeOfString:@"/landscapeinter"].length >= 1)
    {
        NSString *tagValue = [anURL stringByReplacingOccurrencesOfString:@"dfplad://landscapeinter" withString:@""];
        
        if ([tool isRetina] == TRUE)
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kInterstitialAdUnitID_Landscape_Retina"];
            titleLbl = @"Modification Tag Interstitiel Landscape Retina";
            msgLbl = @"Le tag Interstitiel Landscape Retina a été modifié";
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:tagValue forKey:@"kInterstitialAdUnitID_Landscape"];
            titleLbl = @"Modification Tag Interstitiel Landscape";
            msgLbl = @"Le tag Interstitiel Landscape a été modifié";
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleLbl
                                                        message:msgLbl
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    [tool release];
}

@end
