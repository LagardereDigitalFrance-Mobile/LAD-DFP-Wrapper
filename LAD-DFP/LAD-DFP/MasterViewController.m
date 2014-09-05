//
//  MasterViewController.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 18/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "MasterViewController.h"

#import "BannerViewController.h"
#import "InterstitialViewController.h"
#import "ParamsViewController.h"
#import "ParamsViewController_iPadViewController.h"
#import "Constants.h"

//---------------- DEBUG MACRO ------------------

#pragma mark - Debug configuration

//#define DEBUG_ENABLE //Activate Debug log only in this file

/**
 *  - Activate Debug Log for all file  displayif  "DEBUG_VERBOSE" define in GCC PREPROCESSOR MACRO (build setting)
 *  - Activate Debug only in a file if variable DEBUG_ENABLE  define in the file
 */

#if (defined DEBUG_ENABLE || defined DEBUG_VERBOSE)
#   define DLog(fmt, ...) NSLog((@"\n\n%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

//----------------------------------------------

@interface MasterViewController ()
{
    NSMutableArray *_objects;
}

@property (nonatomic, strong) NSMutableArray *objects;

@end

@implementation MasterViewController

@synthesize objects = _objects;

#pragma mark - Initialization Metohds

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.title = NSLocalizedString(@"LAD - DFP", @"LAD - DFP");
    
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
        
        // init datSource
        NSMutableArray *tmp = [[NSMutableArray alloc] initWithObjects:@"Banner Ad",@"Interstitial Ad",@"Parameters", nil];
        [self setObjects:tmp];
        [tmp release];
    }
    
    return self;
}

#pragma mark - Memory Methods

- (void)dealloc
{
    [_detailViewController release];
    [_objects release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Life View Cycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    NSString *object = _objects[indexPath.row];
    cell.textLabel.text = object;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSString *object = _objects[indexPath.row];
    
    if ([object isEqualToString:@"Banner Ad"])
    {
        BannerViewController *tmp = [[BannerViewController alloc] initWithNibName:@"BannerViewController_iPhone" bundle:nil];
        [tmp setTitle:@"Banner Ad"];
        [self.navigationController pushViewController:tmp animated:YES];
        [tmp release];
        
        return;
    }
    else if ([object isEqualToString:@"Interstitial Ad"])
    {
        InterstitialViewController *InterVCtrl = [[InterstitialViewController alloc] initWithNibName:@"InterstitialViewController" bundle:nil];
        [InterVCtrl setTitle:@"Interstitial Ad"];
        [self.navigationController pushViewController:InterVCtrl animated:YES];
        [InterVCtrl release];
        
        return;
    }
    else if ([object isEqualToString:@"Parameters"])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            ParamsViewController *paramsVCtrl = [[ParamsViewController alloc] initWithNibName:@"ParamsViewController" bundle:nil];
            [paramsVCtrl setTitle:@"DFP Params"];
            [self.navigationController pushViewController:paramsVCtrl animated:YES];
            [paramsVCtrl release];
        }
        else
        {
            ParamsViewController_iPadViewController *paramsVCtrl = [[ParamsViewController_iPadViewController alloc] initWithNibName:@"ParamsViewController_iPadViewController" bundle:nil];
            [paramsVCtrl setTitle:@"DFP Params"];
            [self.navigationController pushViewController:paramsVCtrl animated:YES];
            [paramsVCtrl release];
        }
    }
}

#pragma mark - Rotation Methods

- (BOOL)shouldAutorotate
{
    DLog(@" => shouldAutorotate\n\n");
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
        return [UIApplication sharedApplication].statusBarOrientation; // return the current orientation
    }
    
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    else
    {
        return TRUE;
    }
}

@end
