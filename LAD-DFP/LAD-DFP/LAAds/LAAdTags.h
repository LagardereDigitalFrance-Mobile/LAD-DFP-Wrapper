//
//  LAAdTags.h
//  LAD-DFP
//
//  Created by DUPUY Yann on 26/12/12.
//  Updated by DUPUY Yann on 17/07/14.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAAdTags : NSObject
{
    NSString *defaultPortraitTag;
    NSString *defaultLandscapeTag;
    
    NSString *retinaPortraitTag;
    NSString *retinaLandscapeTag;
    
    NSString *iPhone5PortraitTag;
    NSString *iPhone5LandscapeTag;
}

/********* ATTRIBUTES **********/

@property (nonatomic,strong)    NSString *defaultPortraitTag;
@property (nonatomic,strong)    NSString *defaultLandscapeTag;

@property (nonatomic,strong)    NSString *retinaPortraitTag;
@property (nonatomic,strong)    NSString *retinaLandscapeTag;

@property (nonatomic,strong)    NSString *iPhone5PortraitTag;
@property (nonatomic,strong)    NSString *iPhone5LandscapeTag;

@property (nonatomic,strong)    NSString *webContentUrlRef;

/********* METHODS **********/

#pragma mark - Initialization Methods

/// Default Initialization
- (id)initWithTag:(NSString*) aTag;

/// Default initialization with take in account of orientation (Portrait/Landscape)
- (id)initWithPortraitTag:(NSString*) aPortraitTag AndLandscapeTag:(NSString*) aLandscapeTag;

/// Usefull initialization in iPad interstitial/banner ad case (commonly  Portrait/Landscape orientation and iPhone5 don't matter)
- (id)initWithPortraitTag:(NSString*) aPortraitTag AndLandscapeTag:(NSString*) aLandscapeTag AndRetinaPortraitTag:(NSString*) aRetinaPortraitTag AndRetinaLandscapeTag:(NSString*) aRetinaLandscapeTag;

/// Usefull initialization in iPhone interstitial ad case (commonly only Portrait orientation is define)
- (id)initWithTag:(NSString*)aTag AndRetinaTag:(NSString*)aRetinaTag andiPhone5Tag:(NSString*) aniPhone5Tag;

/// Usefull in iPhone banner ad case (commonly only Portrait orientation is define)
- (id)initWithTag:(NSString*)aTag AndRetinaTag:(NSString*)aRetinaTag;

/// Initialization with all Parameters
- (id)initWithPortraitTag:(NSString*) aPortraitTag AndLandscapeTag:(NSString*) aLandscapeTag AndRetinaPortraitTag:(NSString*) aRetinaPortraitTag AndRetinaLandscapeTag:(NSString*) aRetinaLandscapeTag AndiPhone5PortraitTag:(NSString*) aniPhone5PortraitTag AndiPhone5LandscapeTag:(NSString*) aniPhone5LandscapeTag;

#pragma mark - Convenient Methods

/// Define if device is an iPhone 5 model
- (BOOL)isiPhone5;

/// Define if device as a retina screen
- (BOOL)isRetina;

@end
