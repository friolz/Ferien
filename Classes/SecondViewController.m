//
//  SecondViewController.m
//  FerienCountdown
//
//  Created by Tobi on 06.03.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import "SecondViewController.h"
#import "Ferien.h"
#import "BB.h"
#import "BE.h"
#import "BW.h"
#import "BY.h"
#import "HB.h"
#import "HE.h"
#import "HH.h"
#import "MV.h"
#import "NI.h"
#import "NW.h"
#import "RP.h"
#import "SH.h"
#import "SL.h"
#import "SN.h"
#import "ST.h"
#import "TH.h"

@implementation SecondViewController

@synthesize background;

- (IBAction)addtoCal:(id)sender {
    EKEventStore *eventStore = [[EKEventStore alloc] init];    
    
    Ferien *ferien = [[Ferien alloc] init];
    NSArray *ferienList = [ferien getNumberOfHolidays];
    NSError *error;
    for (ferien in ferienList) {
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.calendar = [eventStore defaultCalendarForNewEvents];
        event.allDay = YES;
        event.title = [ferien valueForKey:@"ferienName"];
        event.startDate = [ferien valueForKey:@"beginn"];
        event.endDate = [ferien valueForKey:@"ende"];
        [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kalender" message:@"Ferientermine wurden hinzugefügt!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Ferien *ferien = [[Ferien alloc] init];
    [ferien autorelease];
    return [[ferien getNumberOfHolidays] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Prevents the user from selecting a cell and marking it with blue color
    tableView.allowsSelection = NO;
    // Prevents the user from scrolling the table view
    tableView.scrollEnabled = NO;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell
    Ferien *ferien = [[Ferien alloc] init];
    
    // We take 'id' here, because we get the managed object class at runtime
    id info = [[ferien getNumberOfHolidays] objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@", [info ferienName]];

    NSDateFormatter *formatBeginn = [[NSDateFormatter alloc] init];
    [formatBeginn setDateFormat:@"dd.MM.YY"];
    NSString *beginn = [formatBeginn stringFromDate:[info beginn]];
    
    NSDateFormatter *formatEnde = [[NSDateFormatter alloc] init];
    [formatEnde setDateFormat:@"dd.MM.YY"];
    NSString *ende = [formatEnde stringFromDate:[info ende]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", beginn, ende];
    
    [formatEnde release];
    [formatBeginn release];
    [ferien release];
    [cell autorelease];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
    
// This will refresh the ViewController every time it becomes active
- (void)viewWillAppear:(BOOL)animated {
    // Table View with full-screen dimension
//    CGRect tableViewFrame = self.view.bounds;
    CGRect tableViewFrame = CGRectMake(0, 0, 320, 285);
    
    // Create the Table View
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    
    // Add Table View to the view (UITableView HAS to be a sublass of UIView!)
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    
    [super viewWillAppear:animated];
    [tableView release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) releaseOutlets {
}

- (void)viewDidUnload {
    [self releaseOutlets];
    [super viewDidUnload];
}


- (void)dealloc {
    [self releaseOutlets];
    [super dealloc];
}

@end