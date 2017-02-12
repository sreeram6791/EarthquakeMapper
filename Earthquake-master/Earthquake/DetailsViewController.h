//
//  ViewController.h
//  Earthquake
//
//  Created by SREERAM SREENATH on 12/08/16.
//

#import <UIKit/UIKit.h>
#import "Earthquake.h"
#import "MessageCatalog.h"

@interface DetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) MessageCatalog *messageCatalog;
@property (strong, nonatomic) Earthquake *selectedEarthquake;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissModalButton;
- (IBAction)dismissModalButtonPressed:(id)sender;
- (IBAction)submitAction:(UIButton *)sender;

@end
