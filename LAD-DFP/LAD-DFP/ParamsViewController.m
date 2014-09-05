//
//  ParamsViewController.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 20/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "ParamsViewController.h"
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

@interface ParamsViewController ()

@property (nonatomic, strong)   IBOutlet        UILabel         *bannerLbl;
@property (nonatomic, strong)   IBOutlet        UITextView      *bannerTagTxt;
@property (nonatomic, strong)   IBOutlet        UITextView      *interTagTxt;
@property (nonatomic, strong)   IBOutlet        UILabel         *interLbl;
@property (nonatomic, strong)   IBOutlet        UIScrollView    *scrollContainer;

@end

@implementation ParamsViewController

@synthesize bannerLbl;
@synthesize bannerTagTxt;
@synthesize interLbl;
@synthesize interTagTxt;
@synthesize scrollContainer;


#pragma mark - Initialization Method

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
        [[self scrollContainer] setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
        
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
    [self loadTagData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[self.navigationItem rightBarButtonItem] setEnabled:FALSE];
    [self editingDone];
    
}

#pragma mark - Data Management Methods

- (void)loadTagData
{
    DLog(@" => loadTagData");
    
    LAAdTags *tool = [[LAAdTags alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"kBannerAdUnitID"] != nil)
    {
        if ([tool isRetina] == TRUE)
        {
            [bannerTagTxt setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kBannerAdUnitID_Retina"]];
            [bannerLbl setText:@"DFP -  Banner Retina Ad Tag :"];
        }
        else
        {
            [bannerTagTxt setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kBannerAdUnitID"]];
            [bannerLbl setText:@"DFP -  Banner Ad Tag :"];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID"] != nil)
    {
        if ([tool isiPhone5] == TRUE)
        {
            [interTagTxt setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID_iPhone5"]];
            [interLbl setText:@"DFP -  Interstitial iPhone5 Ad Tag :"];
        }
        else if ([tool isRetina] == TRUE)
        {
            [interTagTxt setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID_Retina"]];
            [interLbl setText:@"DFP -  Interstitial Retina Ad Tag :"];
        }
        else
        {
            [interTagTxt setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"kInterstitialAdUnitID"]];
            [interLbl setText:@"DFP -  Interstitial Ad Tag :"];
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
    
    //Banner Case
    if ([tool isRetina] == TRUE)
    {
        [self saveTagValue:[bannerTagTxt text] ForAdKey:@"kBannerAdUnitID_Retina"];
    }
    else
    {
        [self saveTagValue:[bannerTagTxt text] ForAdKey:@"kBannerAdUnitID"];
    }
    
    //Interstitial Case
    if ([tool isiPhone5] == TRUE)
    {
        [self saveTagValue:[interTagTxt text] ForAdKey:@"kInterstitialAdUnitID_iPhone5"];
    }
    else if ([tool isRetina] == TRUE)
    {
        [self saveTagValue:[interTagTxt text] ForAdKey:@"kInterstitialAdUnitID_Retina"];
    }
    else
    {
        [self saveTagValue:[interTagTxt text] ForAdKey:@"kInterstitialAdUnitID"];
    }
    
    [tool release];
}

- (IBAction)resetToDefaultTags:(id)sender
{
    DLog(@" => resetToDefaultTags");
    
    LAAdTags *tool = [[LAAdTags alloc] init];
    
    //Banner Case
    [self saveTagValue:kBannerAdUnitID ForAdKey:@"kBannerAdUnitID"];
    [self saveTagValue:kBannerAdUnitID_Retina ForAdKey:@"kBannerAdUnitID_Retina"];
    
    if ([tool isRetina] == TRUE)
    {
        [bannerTagTxt setText:kBannerAdUnitID_Retina];
    }
    else
    {
        [bannerTagTxt setText:kBannerAdUnitID];
    }
    
    //Interstitial Case
    [self saveTagValue:kInterstitialAdUnitID ForAdKey:@"kInterstitialAdUnitID"];
    [self saveTagValue:kInterstitialAdUnitID_Retina ForAdKey:@"kInterstitialAdUnitID_Retina"];
    [self saveTagValue:kInterstitialAdUnitID_iPhone5 ForAdKey:@"kInterstitialAdUnitID_iPhone5"];
    
    if ([tool isiPhone5] == TRUE)
    {
        [interTagTxt setText:kInterstitialAdUnitID_iPhone5];
    }
    else if([tool isRetina] == TRUE)
    {
        [interTagTxt setText:kInterstitialAdUnitID_Retina];
    }
    else
    {
        [interTagTxt setText:kInterstitialAdUnitID];
    }
    
    [tool release];
}

- (void)editingDone
{
    [bannerTagTxt resignFirstResponder];
    [interTagTxt resignFirstResponder];
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    DLog(@" =>  textViewDidBeginEditing");
    
    [[self.navigationItem rightBarButtonItem] setEnabled:TRUE];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    DLog(@" =>  textViewShouldEndEditing");
    
    LAAdTags *tool = [[LAAdTags alloc] init];
    
    NSString *tagValue = textView.text;
    
    if (textView == bannerTagTxt)
    {
        NSString *keyValue = @"kBannerAdUnitID";
        
        if ([tool isRetina] == TRUE)
        {
            keyValue = @"kBannerAdUnitID_Retina";
        }
        
        [self saveTagValue:tagValue ForAdKey:keyValue];
    }
    else if (textView == interTagTxt)
    {
        NSString *keyValue = @"kInterstitialAdUnitID";
        
        if ([tool isiPhone5] == TRUE)
        {
            keyValue = @"kInterstitialAdUnitID_iPhone5";
        }
        else if ([tool isRetina] == TRUE)
        {
            keyValue = @"kInterstitialAdUnitID_Retina";
        }
        
        [self saveTagValue:tagValue ForAdKey:keyValue];
    }
    
    [textView resignFirstResponder];
    
    [tool release];
    
    return TRUE;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    DLog(@" =>  textViewDidEndEditing");
    
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
    [bannerTagTxt release];
    [bannerLbl release];
    
    [interTagTxt release];
    [interLbl release];
    
    [scrollContainer release];
    [super dealloc];
}

@end
