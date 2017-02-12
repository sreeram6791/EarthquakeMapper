//
//  Earthquake.h
//  Earthquake
//
//  Created by SREERAM SREENATH on 12/08/16.
//

#import <Foundation/Foundation.h>

@interface Earthquake : NSObject

@property (strong, nonatomic) NSNumber *magnitude;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSNumber *dateAndTime;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *depth;

@end
