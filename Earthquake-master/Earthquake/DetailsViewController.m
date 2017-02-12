//
//  ViewController.m
//  Earthquake
//
//  Created by SREERAM SREENATH on 12/08/16.
//

#import "DetailsViewController.h"
#import "Message.h"
#import "MessageCatalog.h"

@interface DetailsViewController ()<UITableViewDataSource,UITableViewDelegate>;

@property (weak, nonatomic) IBOutlet UIButton *Submit;
@property (weak, nonatomic) IBOutlet UITextView *textBox;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation DetailsViewController{
    NSMutableArray *tableData;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.table.delegate = self;
    self.table.dataSource = self;
   
    _table.alwaysBounceVertical = NO;
    _table.scrollEnabled = YES;
    _table.showsVerticalScrollIndicator = YES;
    
    [self setupUI];
    
}
#pragma Back Button
- (IBAction)dismissModalButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma Submit Button
- (IBAction)submitAction:(UIButton *)sender {
    
    Message *message = [[Message alloc] init];
    message.title = self.selectedEarthquake.title;
    message.timeSubmitted = [NSDate date];
    message.message = _textBox.text;
    
    if([_textBox.text  isEqualToString: @"Enter Ticker Message Here...."] || [_textBox.text isEqualToString: @""] || (_textBox.text.length > 200)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Message"
                                                        message:@"Enter Correct Message and Try Submitting again"
                                                       delegate:nil
                                              cancelButtonTitle:@"TRY AGAIN"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else{
        
        [self.messageCatalog.messageCatalog addObject:message];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    
}

- (void)setupUI
{
    self.titleLabel.text = self.selectedEarthquake.title;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate dateWithTimeIntervalSince1970:[self.selectedEarthquake.dateAndTime doubleValue]/1000]];
    self.dateAndTimeLabel.text = [NSString stringWithFormat:@"%ld - %ld - %ld", (long)[components month], (long)[components day], (long)[components year] ];
    
    self.magnitudeLabel.text = [self.selectedEarthquake.magnitude stringValue];
    
    self.placeLabel.text = [NSString stringWithFormat:@" Location [%@ , %@]  Depth - %@ Km", [self.selectedEarthquake.latitude stringValue], [self.selectedEarthquake.longitude stringValue], [self.selectedEarthquake.depth stringValue] ];
    
    //NSLog(@"%@, %@",_selectedEarthquake.latitude,_selectedEarthquake.longitude);
    
    self.dismissModalButton.layer.cornerRadius = 8;
    self.dismissModalButton.layer.borderWidth = 2;
//    self.dismissModalButton.layer.borderColor = [UIColor blueColor].CGColor;
//    self.dismissModalButton.backgroundColor = [UIColor cyanColor];
    self.Submit.layer.cornerRadius = 8;
    self.Submit.layer.borderWidth = 2;
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    tableData = self.messageCatalog.messageCatalog;
    return [tableData count];
}

// Content within the cell for each row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableData = self.messageCatalog.messageCatalog;
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                simpleTableIdentifier];
    }

    Message *message = [tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = message.title;
    cell.detailTextLabel.text = message.message;

    _table.alwaysBounceVertical = NO;
    _table.scrollEnabled = YES;
    [_table setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    return cell;
}

@end
