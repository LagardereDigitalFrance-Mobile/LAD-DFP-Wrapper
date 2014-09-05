//
//  GeolocManager.m
//  LAD-DFP
//
//  Created by GA-EL MOUDEN Yassin on 12/08/13.
//  Copyright (c) 2013 DUPUY Yann. All rights reserved.
//

#import "GeolocManager.h"

// définition du nombre de secondes pour la prochaine mise à jour de la position de l'utilisateur
#define kTimeGeoloc 60

@interface GeolocManager () <CLLocationManagerDelegate>

//private instances
@property (retain,nonatomic) CLLocationManager * locationManager;

@end

@implementation GeolocManager

/********************************************************************************/
#pragma mark - Singleton

+(GeolocManager *)sharedInstance
{
    static GeolocManager * sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[GeolocManager alloc] init];
        
    });
    
    return sharedInstance;
}

/********************************************************************************/
#pragma mark - Initialization Methods

- (id)init
{
    self = [super init];
    
    if(self)
    {
        CLLocationManager * locationManagerTmp = [[CLLocationManager alloc] init];
        self.locationManager = locationManagerTmp;
        [locationManagerTmp release];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return self;
}

/********************************************************************************/
#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
}

/********************************************************************************/
#pragma mark - Public Méthods

- (CLLocation *)getLastLocation
{
    //on check si on doit effectuer une mise à jour de la location
    
    if(!_locationManager.location || ABS([_locationManager.location.timestamp timeIntervalSinceNow])>kTimeGeoloc)
    {
        [_locationManager startUpdatingLocation];
    }
    
    return _locationManager.location;
}

@end
