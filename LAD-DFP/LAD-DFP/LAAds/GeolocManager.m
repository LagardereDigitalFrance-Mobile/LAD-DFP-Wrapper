//
//  GeolocManager.m
//  LAD-DFP
//
//  Created by GA-EL MOUDEN Yassin on 12/08/13.
//  Copyright (c) 2013 DUPUY Yann. All rights reserved.
//

#import "GeolocManager.h"

//définition du nombre de secondes pour la prochaine mise à jour de la position de l'utilisateur
#define kTimeGeoloc (60)

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


-(id)init
{
    self = [super init];
    
    if(self)
    {
        CLLocationManager * locationManagerTmp = [[CLLocationManager alloc] init];
        self.locationManager = locationManagerTmp;
        [locationManagerTmp release];
        _locationManager.delegate = self;
        
#ifdef DEBUG
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
#else
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
#endif
        
    }
    
    return self;
}



/********************************************************************************/
#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    {
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
        {
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error %@",error);
}


/********************************************************************************/
#pragma mark - Public Méthods

- (CLLocation *)getLastLocation
{
    if(!_locationManager.location || ABS([_locationManager.location.timestamp timeIntervalSinceNow])>kTimeGeoloc)
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
        {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                [_locationManager requestWhenInUseAuthorization];
            }else if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
                [_locationManager startUpdatingLocation];
            }
            
        }else {
            [_locationManager startUpdatingLocation];
        }
    }
    
    return _locationManager.location;
    
}


@end
