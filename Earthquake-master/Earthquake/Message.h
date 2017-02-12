//
//  Message.h
//  Earthquake
//
//  Created by SREERAM SREENATH on 12/17/16.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *timeSubmitted;


@end
