//
//  MapViewController.m
//  Earthquake
//
//  Created by SREERAM SREENATH on 12/08/16.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *earthquakesArray;

- (IBAction)reset:(UIButton *)sender;

@end
