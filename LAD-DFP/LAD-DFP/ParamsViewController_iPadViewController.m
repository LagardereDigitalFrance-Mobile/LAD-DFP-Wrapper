//
//  ParamsViewController_iPadViewController.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 26/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "ParamsViewController_iPadViewController.h"

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

#define kDoneBtnTag 7773344

@interface ParamsViewController_iPadViewController ()

@property (nonatomic, strong)   IBOutlet        UILabel         *bannerPortraitLbl;
@property (nonatomic, strong)   IBOutlet        UITextView      *bannerTagTxtPortrait;
@property (nonatomic, strong)   IBOutlet        UITextView      *bannerTagTxtLandscape;
@property (nonatomic, strong)   IBOutlet        UILabel         *interPortraitLbl;
@property (nonatomic, strong)   IBOutlet        UITextView      *interTagTxtPortrait;
@property (nonatomic, strong)   IBOutlet        UITextView      *interTagTxtLandscape;

@end

@implementation ParamsViewController_iPadViewController

@synthesize bannerPortraitLbl;
@synthesize bannerTagTxtPortrait;
@synthesize bannerTagTxtLandscape;
@synthesize interPortraitLbl;
@synthesize interTagTxtPortrait;
@synthesize interTagTxtLandscape;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editingDone)];
        [doneBtn setTag:kDoneBtnTag];
        [self.navigationItem setRightBarButtonItem:doneBtn];
        [doneBtn release];
        
        [[self.navigationItem rightBarButtonItem] setEnabled:FALSE];
    }
    
    return self;
}

#pragma mark - View Life Cycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadTagData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[self.navigationItem rightBarButtonItem] setEnabled:FALSE];
    [self editingDone];
}

#pragma mark - Data Management Methods

- (void)loadTagData
{
    DLog(@" => loadTagData");
    
    LAAdTags *tool = [[LAAdTags alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"kBannerAdUnitID_Portrait"] != nil)
    {
        if ([tool isRetina] == TRUE)
        {
            [bannerTagTxtPortrait setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kBannerAdUnitID_Portrait_Retina"]];
            [bannerTagTxtLandscape setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kBannerAdUnitID_Landscape_Retina"]];
            [bannerPortraitLbl setText:@"DFP -  Banner Retina Ad Tag  (Portrait/Landscape) :"];
        }
        else
        {
            [bannerTagTxtPortrait setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kBannerAdUnitID_Portrait"]];
            [bannerTagTxtLandscape setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kBannerAdUnitID_Landscape"]];
            [bannerPortraitLbl setText:@"DFP -  Banner Ad Tag  (Portrait/Landscape) :"];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID_Portrait"] != nil)
    {
        if ([tool isRetina] == TRUE)
        {
            [interTagTxtPortrait setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID_Portrait_Retina"]];
            [interTagTxtLandscape setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID_Landscape_Retina"]];
            [interPortraitLbl setText:@"DFP -  Interstitial Retina Ad Tag (Portrait/Landscape):"];
        }
        else
        {
            [interTagTxtPortrait setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID_Portrait"]];
            [interTagTxtLandscape setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID_Landscape"]];
            [interPortraitLbl setText:@"DFP -  Interstitial Ad Tag (Portrait/Landscape):"];
        }
    }
    
    [tool release];
}

- (void)saveTagValue:(NSString*)aTag ForAdKey:(NSString*)adKey
{
    DLog(@" => saveTagValue: %@ ForAdKey:%@",aTag,adKey);
    
    [[NSUserDefaults standardUserDefaults] setObject:aTag forKey:adKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Action Methods

- (IBAction)saveTags:(id)sender
{
    DLog(@" => saveTags");
    
    LAAdTags *tool = [[LAAdTags alloc] init];
    
    if ([tool isRetina] == TRUE)
    {
        [self saveTagValue:[bannerTagTxtPortrait text] ForAdKey:@"kBannerAdUnitID_Portrait_Retina"];
        [self saveTagValue:[bannerTagTxtLandscape text] ForAdKey:@"kBannerAdUnitID_Landscape_Retina"];
        
        [self saveTagValue:[interTagTxtPortrait text] ForAdKey:@"kInterstitialAdUnitID_Portrait_Retina"];
        [self saveTagValue:[interTagTxtLandscape text] ForAdKey:@"kInterstitialAdUnitID_Landscape_Retina"];
    }
    else
    {
        [self saveTagValue:[bannerTagTxtPortrait text] ForAdKey:@"kBannerAdUnitID_Portrait"];
        [self saveTagValue:[bannerTagTxtLandscape text] ForAdKey:@"kBannerAdUnitID_Landscape"];
        
        [self saveTagValue:[interTagTxtPortrait text] ForAdKey:@"kInterstitialAdUnitID_Portrait"];
        [self saveTagValue:[interTagTxtLandscape text] ForAdKey:@"kInterstitialAdUnitID_Landscape"];
    }
    
    [tool release];
}

- (IBAction)resetToDefaultTags:(id)sender
{
    DLog(@" => resetToDefaultTags");
    
    LAAdTags *tool = [[LAAdTags alloc] init];
    
    if ([tool isRetina] == TRUE)
    {
        [self saveTagValue:kBannerAdUnitID_Portrait_Retina ForAdKey:@"kBannerAdUnitID_Portrait_Retina"];
        [self saveTagValue:kBannerAdUnitID_Landscape_Retina ForAdKey:@"kBannerAdUnitID_Landscape_Retina"];
        
        [self saveTagValue:kInterstitialAdUnitID_Portrait_Retina ForAdKey:@"kInterstitialAdUnitID_Portrait_Retina"];
        [self saveTagValue:kInterstitialAdUnitID_Landscape_Retina ForAdKey:@"kInterstitialAdUnitID_Landscape_Retina"];
        
        [bannerTagTxtPortrait setText:kBannerAdUnitID_Portrait_Retina];
        [bannerTagTxtLandscape setText:kBannerAdUnitID_Landscape_Retina];
        
        [interTagTxtPortrait setText:kInterstitialAdUnitID_Portrait_Retina];
        [interTagTxtLandscape setText:kBannerAdUnitID_Landscape_Retina];
    }
    else
    {
        [self saveTagValue:kBannerAdUnitID_Portrait ForAdKey:@"kBannerAdUnitID_Portrait"];
        [self saveTagValue:kBannerAdUnitID_Landscape ForAdKey:@"kBannerAdUnitID_Landscape"];
        
        [self saveTagValue:kInterstitialAdUnitID_Portrait ForAdKey:@"kInterstitialAdUnitID_Portrait"];
        [self saveTagValue:kInterstitialAdUnitID_Landscape ForAdKey:@"kInterstitialAdUnitID_Landscape"];
        
        [bannerTagTxtPortrait setText:kBannerAdUnitID_Portrait];
        [bannerTagTxtLandscape setText:kBannerAdUnitID_Landscape];
        
        [interTagTxtPortrait setText:kInterstitialAdUnitID_Portrait];
        [interTagTxtLandscape setText:kBannerAdUnitID_Landscape];
    }
    
    [tool release];
}

- (void)editingDone
{
    [bannerTagTxtPortrait resignFirstResponder];
    [bannerTagTxtLandscape resignFirstResponder];
    
    [interTagTxtPortrait resignFirstResponder];
    [interTagTxtLandscape resignFirstResponder];
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    DLog(@" => textViewDidBeginEditing");
    
    [[self.navigationItem rightBarButtonItem] setEnabled:TRUE];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    DLog(@" => textViewShouldEndEditing");
    
    NSString *tagValue = textView.text;
    NSString *keyValue = @"";
    LAAdTags *tool = [[LAAdTags alloc] init];
    
    if (textView == bannerTagTxtPortrait)
    {
        keyValue = @"kBannerAdUnitID_Portrait";
        
        if ([tool isRetina] == TRUE)
        {
            keyValue = @"kBannerAdUnitID_Portrait_Retina";
        }
        
        [self saveTagValue:tagValue ForAdKey:keyValue];
    }
    else if (textView == bannerTagTxtLandscape)
    {
        keyValue = @"kBannerAdUnitID_Landscape";
        
        if ([tool isRetina] == TRUE)
        {
            keyValue = @"kBannerAdUnitID_Landscape_Retina";
        }
        
        [self saveTagValue:tagValue ForAdKey:keyValue];
    }
    else if (textView == interTagTxtPortrait)
    {
        keyValue = @"kInterstitialAdUnitID_Portrait";
        
        if ([tool isRetina] == TRUE)
        {
            keyValue = @"kInterstitialAdUnitID_Portrait_retina";
        }
        
        [self saveTagValue:tagValue ForAdKey:keyValue];
    }
    else if (textView == interTagTxtLandscape)
    {
        keyValue = @"kInterstitialAdUnitID_Landscape";
        
        if ([tool isRetina] == TRUE)
        {
            keyValue = @"kInterstitialAdUnitID_Landscape_Retina";
        }
        
        [self saveTagValue:tagValue ForAdKey:keyValue];
    }
    
    [textView resignFirstResponder];
    
    [tool release];
    
    return TRUE;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    DLog(@" => textViewDidEndEditing");
    
    [[self.navigationItem rightBarButtonItem] setEnabled:FALSE];
}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [bannerPortraitLbl release];
    [bannerTagTxtPortrait release];
    [bannerTagTxtLandscape release];
    
    [interPortraitLbl release];
    [interTagTxtPortrait release];
    [interTagTxtLandscape release];

    [super dealloc];
}

@end
