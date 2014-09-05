//
//  GeolocManager.h
//  LAD-DFP
//
//  Created by GA-EL MOUDEN Yassin on 12/08/13.
//  Copyright (c) 2013 DUPUY Yann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GeolocManager : NSObject

+ (GeolocManager *)sharedInstance;
- (CLLocation *)getLastLocation;


@end
