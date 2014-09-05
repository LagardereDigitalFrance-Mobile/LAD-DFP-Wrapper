//
//  LAAdTags.m
//  LAD-DFP
//
//  Created by DUPUY Yann on 26/12/12.
//  Updated by DUPUY Yann on 17/07/14.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import "LAAdTags.h"

@implementation LAAdTags

@synthesize defaultPortraitTag;
@synthesize defaultLandscapeTag;

@synthesize retinaPortraitTag;
@synthesize retinaLandscapeTag;

@synthesize iPhone5PortraitTag;
@synthesize iPhone5LandscapeTag;

@synthesize webContentUrlRef;

#pragma mark - Initialization Methods

/// Default Initialization
- (id)initWithTag:(NSString*) aTag
{
    self = [super init];
    
    if (self)
    {
        [self setDefaultPortraitTag:aTag];
        [self setDefaultLandscapeTag:aTag];
        
        [self setRetinaPortraitTag:aTag];
        [self setRetinaLandscapeTag:aTag];
        
        [self setIPhone5PortraitTag:aTag];
        [self setIPhone5LandscapeTag:aTag];
    }
    
    return  self;
}

/// Default initialization with take in account of orientation (Portrait/Landscape)
- (id)initWithPortraitTag:(NSString*) aPortraitTag AndLandscapeTag:(NSString*) aLandscapeTag
{
    self = [super init];
    
    if (self)
    {
        [self setDefaultPortraitTag:aPortraitTag];
        [self setDefaultLandscapeTag:aLandscapeTag];
        
        [self setRetinaPortraitTag:aPortraitTag];
        [self setRetinaLandscapeTag:aLandscapeTag];
        
        [self setIPhone5PortraitTag:aPortraitTag];
        [self setIPhone5LandscapeTag:aLandscapeTag];
    }
    
    return  self;
}

/// Usefull initialization in iPad interstitial/banner ad case
- (id)initWithPortraitTag:(NSString*) aPortraitTag AndLandscapeTag:(NSString*) aLandscapeTag AndRetinaPortraitTag:(NSString*) aRetinaPortraitTag AndRetinaLandscapeTag:(NSString*) aRetinaLandscapeTag
{
    self = [super init];
    
    if (self)
    {
        [self setDefaultPortraitTag:aPortraitTag];
        [self setDefaultLandscapeTag:aLandscapeTag];
        
        [self setRetinaPortraitTag:aRetinaPortraitTag];
        [self setRetinaLandscapeTag:aRetinaLandscapeTag];
        
        [self setIPhone5PortraitTag:aRetinaPortraitTag];
        [self setIPhone5LandscapeTag:aRetinaLandscapeTag];
    }
    
    return  self;
}

/// Usefull initialization in iPhone interstitial ad case
- (id)initWithTag:(NSString*)aTag AndRetinaTag:(NSString*)aRetinaTag andiPhone5Tag:(NSString*) aniPhone5Tag
{
    self = [super init];
    
    if (self)
    {
        [self setDefaultPortraitTag:aTag];
        [self setDefaultLandscapeTag:aTag];
        
        [self setRetinaPortraitTag:aRetinaTag];
        [self setRetinaLandscapeTag:aRetinaTag];
        
        [self setIPhone5PortraitTag:aniPhone5Tag];
        [self setIPhone5LandscapeTag:aniPhone5Tag];
    }
    
    return  self;
}

/// Usefull in iPhone banner ad case
- (id)initWithTag:(NSString*)aTag AndRetinaTag:(NSString*)aRetinaTag
{
    self = [super init];
    
    if (self)
    {
        [self setDefaultPortraitTag:aTag];
        [self setDefaultLandscapeTag:aTag];
        
        [self setRetinaPortraitTag:aRetinaTag];
        [self setRetinaLandscapeTag:aRetinaTag];
        
        [self setIPhone5PortraitTag:aRetinaTag];
        [self setIPhone5LandscapeTag:aRetinaTag];
    }
    
    return  self;
}

/// Initialization with all Parameters
- (id)initWithPortraitTag:(NSString*) aPortraitTag AndLandscapeTag:(NSString*) aLandscapeTag AndRetinaPortraitTag:(NSString*) aRetinaPortraitTag AndRetinaLandscapeTag:(NSString*) aRetinaLandscapeTag AndiPhone5PortraitTag:(NSString*) aniPhone5PortraitTag AndiPhone5LandscapeTag:(NSString*) aniPhone5LandscapeTag
{
    self = [super init];
    
    if (self)
    {
        [self setDefaultPortraitTag:aPortraitTag];
        [self setDefaultLandscapeTag:aLandscapeTag];
        
        [self setRetinaPortraitTag:aRetinaPortraitTag];
        [self setRetinaLandscapeTag:aRetinaLandscapeTag];
        
        [self setIPhone5PortraitTag:aniPhone5PortraitTag];
        [self setIPhone5LandscapeTag:aniPhone5LandscapeTag];
    }
    
    return  self;
}

#pragma mark - Memory Methods

- (void)dealloc
{
    if (defaultPortraitTag != nil)
    {
        [defaultPortraitTag release]; defaultPortraitTag = nil;
    }
    
    if (defaultLandscapeTag != nil)
    {
        [defaultLandscapeTag release]; defaultLandscapeTag = nil;
    }
    
    if (retinaPortraitTag != nil)
    {
        [retinaPortraitTag release]; retinaPortraitTag = nil;
    }
    
    if (retinaLandscapeTag != nil)
    {
        [retinaLandscapeTag release]; retinaLandscapeTag = nil;
    }
    
    if (iPhone5PortraitTag != nil)
    {
        [iPhone5PortraitTag release]; iPhone5PortraitTag = nil;
    }
    
    if (iPhone5LandscapeTag != nil)
    {
        [iPhone5LandscapeTag release]; iPhone5LandscapeTag = nil;
    }
    
    if (webContentUrlRef != nil)
    {
        [webContentUrlRef release]; webContentUrlRef = nil;
    }
    
    [super dealloc];
}

#pragma mark - Convenient Methods

/// Define if device is an iPhone 5 model
- (BOOL)isiPhone5
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) //case iPhone
    {
        if ([UIScreen mainScreen].bounds.size.height > 480)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
}

/// Define if device as a retina screen
- (BOOL)isRetina
{
    if ([UIScreen mainScreen].scale > 1.0)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

@end
