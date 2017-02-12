//
//  MapViewController.m
//  Earthquake
//
//  Created by SREERAM SREENATH on 12/08/16.
//
#import "MapViewController.h"
#import "Earthquake.h"
#import "EarthquakeNetworking.h"
#import "DetailsViewController.h"
#import "MessageCatalog.h"


@interface MapViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *startDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDate;
@property (weak, nonatomic) IBOutlet UIPickerView *magPicker;
@property (weak, nonatomic) IBOutlet UIButton *reset;


@property (strong, nonatomic) NSMutableArray *earthquakePinsArray;
@property (strong, nonatomic) NSArray *earthquakeObjectsArray;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) EarthquakeNetworking *networkingManger;
@property (strong, nonatomic) NSArray *pickerData;

@property (strong, nonatomic) MessageCatalog *mc;
@end

@implementation MapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.networkingManger = [[EarthquakeNetworking alloc] init];
    
    [self.networkingManger fetchEarthquakeDataFrom:[self getDateFromOneYearAgo:[NSDate date]]
                                                to:[self formateDate:[NSDate date]]
                                    forMagnitudeOf:[NSNumber numberWithInt:6]
                                        completion:^(NSArray *data) {
                                            self.earthquakeObjectsArray = data;
                                        }];
    
    self.mapView.userInteractionEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    self.mapView.zoomEnabled = true;
    
    self.reset.layer.cornerRadius = 8;
    self.reset.layer.borderWidth = 2;
    
    _pickerData = @[@" 1 ", @" 2 ", @" 3 ", @" 4 ", @" 5 ", @" 6 ", @" 7 ", @" 8 ", @" 9 ", @" 10 ", @" 11 ", @" 12 "];
    self.magPicker.dataSource = self;
    self.magPicker.delegate = self;
    
    self.mc = [[MessageCatalog alloc] init];
    self.mc.messageCatalog = [[NSMutableArray alloc] init];
}

- (void)setEarthquakeObjectsArray:(NSArray *)earthquakeObjectsArray
{
    _earthquakeObjectsArray = earthquakeObjectsArray;
    NSArray *mapAnnotations = [self convertEarthquakeObjectsIntoCoordinates:self.earthquakeObjectsArray];
    [self.mapView addAnnotations:mapAnnotations];
    [self.mapView showAnnotations:mapAnnotations animated:YES];
}

- (NSString *)formateDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *usgsDateStyle = [formatter stringFromDate:date];
    
    return usgsDateStyle;
}

- (NSString *)getDateFromOneYearAgo:(NSDate *)today
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-1];
    
    NSDate *oneYearAgo = [currentCalendar dateByAddingComponents:offsetComponents toDate:today options:0];
    
    return [self formateDate:oneYearAgo];
}

- (NSArray *)convertEarthquakeObjectsIntoCoordinates:(NSArray *)earthquakeObjects
{
    self.earthquakePinsArray = [NSMutableArray array];
    
    for (Earthquake *earthquake in earthquakeObjects) {
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)[earthquake.latitude doubleValue], (CLLocationDegrees)[earthquake.longitude doubleValue]);
        myAnnotation.title = earthquake.title;

        [self.earthquakePinsArray addObject:myAnnotation];
    }
    
    return (NSArray *)self.earthquakePinsArray;
}

#pragma MapKit Delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"earthquake"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"earthquake"];
        aView.canShowCallout = YES;
        
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.rightCalloutAccessoryView = rightButton;
    }
    
    aView.annotation = annotation;
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"MapToEarthquakeDetailsSegue" sender:view];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[MKAnnotationView class]]) {
        NSInteger index = [self.earthquakePinsArray indexOfObject:((MKAnnotationView *)sender).annotation];
        Earthquake *earthquake = self.earthquakeObjectsArray[index];
        
        if([segue.identifier isEqualToString:@"MapToEarthquakeDetailsSegue"]) {
            DetailsViewController *detailsVC = (DetailsViewController *)segue.destinationViewController;
            detailsVC.selectedEarthquake = earthquake;
            
            detailsVC.messageCatalog = self.mc;
            detailsVC.messageCatalog.messageCatalog = self.mc.messageCatalog;
        }
    }
}

//#pragma datePicker methods
//
//-(NSString *)startDateFetch
//{
//    NSDate *date;
//    date = [_startDate date];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSString *usgsDateStyle = [formatter stringFromDate:date];
//    return usgsDateStyle;
//}
//
//
//-(NSString *)endDateFetch
//{
//    NSDate *date;
//    date = [_endDate date];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSString *usgsDateStyle = [formatter stringFromDate:date];
//    return usgsDateStyle;
//}

#pragma MAGNITUDE Picker

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}



#pragma RELOAD

- (IBAction)reset:(UIButton *)sender {
    
    NSMutableArray * annotationsToRemove = [ self.mapView.annotations mutableCopy ] ;
    [ self.mapView removeAnnotations:annotationsToRemove ] ;
    
    _earthquakeObjectsArray = nil;
    _earthquakeObjectsArray = [[NSArray alloc] init];
    
    
    if([[_startDate date] compare: [_endDate date]] == NSOrderedDescending) // if start is later in time than end
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Dates"
                                                        message:@"StartDate MUST be before EndDate!!"
                                                       delegate:nil
                                              cancelButtonTitle:@"TRY AGAIN"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    self.networkingManger = [[EarthquakeNetworking alloc] init];
    
    [self.networkingManger fetchEarthquakeDataFrom:[self formateDate:[_startDate date]]
                                                to:[self formateDate:[_endDate date]]
                                    forMagnitudeOf:[NSNumber numberWithInteger:[_magPicker selectedRowInComponent:0]]
                                        completion:^(NSArray *data) {
                                            self.earthquakeObjectsArray = data;
                                        }];
    
    self.reset.layer.cornerRadius = 8;
    self.reset.layer.borderWidth = 2;
//    self.dismissModalButton.layer.borderColor = [UIColor blueColor].CGColor;
//    self.dismissModalButton.backgroundColor = [UIColor cyanColor];
    
    
    self.mapView.userInteractionEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    self.mapView.zoomEnabled = true;
    
    
    
}
@end
