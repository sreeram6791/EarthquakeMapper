//
//  EarthquakeNetworking.h
//  Earthquake
//
//
//  Created by SREERAM SREENATH on 12/08/16.
//

#import <Foundation/Foundation.h>

typedef void (^EarthquakeDataRequestCompletion)(NSArray *data);

@interface EarthquakeNetworking : NSObject

- (void)fetchEarthquakeDataFrom:(NSString *)startDate
                             to:(NSString *)endDate
                 forMagnitudeOf:(NSNumber *)magnitude
                     completion:(EarthquakeDataRequestCompletion)completion;

@end
