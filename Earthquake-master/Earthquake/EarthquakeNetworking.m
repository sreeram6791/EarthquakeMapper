//
//  EarthquakeNetworking.m
//  Earthquake
//
//
//  Created by SREERAM SREENATH on 12/08/16.
//
#import "EarthquakeNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "Earthquake.h"

NSString * const EarthquakeBaseQueryAPI = @"http://earthquake.usgs.gov/fdsnws/event/1/query";


@implementation EarthquakeNetworking

- (void)fetchEarthquakeDataFrom:(NSString *)startDate
                             to:(NSString *)endDate
                 forMagnitudeOf:(NSNumber *)magnitude
                     completion:(EarthquakeDataRequestCompletion)completion
{
    NSDictionary *parameters = @{@"starttime" : startDate,
                                 @"endtime" : endDate,
                                 @"minmagnitude" : magnitude,
                                 @"format" : @"geojson",
                                 @"latitude" : @"42.360082",
                                 @"longitude" : @"-71.058880",
                                 @"maxradiuskm" : @"20000"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager GET:EarthquakeBaseQueryAPI
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
             NSArray *earquakesArray = [[NSArray alloc] initWithArray:[self parseEarthquakeResponse:responseObject]];
             if (completion) {
                 completion(earquakesArray);
             }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"\n\n\nERROR: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Results Denied by Server"
                                                        message:@"Change filters to match fewer results!!!"
                                                       delegate:nil
                                              cancelButtonTitle:@"TRY AGAIN"
                                              otherButtonTitles:nil];
        [alert show];
        
    }];
    
}

- (NSMutableArray *)parseEarthquakeResponse:(NSDictionary *)data
{
    NSMutableArray *earthquakeItems = [NSMutableArray array];

    NSArray *collectiveEarthquakesArray = [data objectForKey:@"features"];
    
    for (NSDictionary *IndividualEarthquakeDict in collectiveEarthquakesArray) {
        NSDictionary *earthquakeStatsDict = [IndividualEarthquakeDict objectForKey:@"properties"];
        
        Earthquake *earthquake = [[Earthquake alloc] init];
        earthquake.magnitude = [earthquakeStatsDict objectForKey:@"mag"];
        earthquake.place = [earthquakeStatsDict objectForKey:@"place"];
        earthquake.dateAndTime = [earthquakeStatsDict objectForKey:@"time"];
        earthquake.url = [earthquakeStatsDict objectForKey:@"url"];
        earthquake.title = [earthquakeStatsDict objectForKey:@"title"];
        
        NSDictionary *earthquakeLocationDict = [IndividualEarthquakeDict objectForKey:@"geometry"];
        NSArray *earthquakeCoordinatesArray = [earthquakeLocationDict objectForKey:@"coordinates"];
        earthquake.longitude = [earthquakeCoordinatesArray objectAtIndex:0];
        earthquake.latitude = [earthquakeCoordinatesArray objectAtIndex:1];
        earthquake.depth = [earthquakeCoordinatesArray objectAtIndex:2];
        
        [earthquakeItems addObject:earthquake];
    }

    return earthquakeItems;
}



@end
