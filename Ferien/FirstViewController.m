//
//  FirstViewController.m
//  Ferien
//
//  Created by Tobi on 10.01.13.
//  Copyright (c) 2013 Tobi. All rights reserved.
//

#import "FirstViewController.h"
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

@interface FirstViewController ()

@end

@implementation FirstViewController

- (IBAction)calendar:(id)sender {
    NSString *string;
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    Ferien *ferien = [[Ferien alloc] init];
    
    if (self.holidayFlag == NO) {
        string = [NSString stringWithFormat:@"Noch %@ bis zum Beginn der Ferien. App unter: %@", [ferien getDateAsString], [NSURL URLWithString: @"http://bit.ly/Xf5jcS"]];
        [activityItems addObject:string];
    } else {
        string = [NSString stringWithFormat:@"Noch %@ bis zum Ende der Ferien. App unter: %@", [ferien getDateAsString], [NSURL URLWithString: @"http://bit.ly/Xf5jcS"]];
        [activityItems addObject:string];
    }
    
    NSArray *ferienList = [ferien getNumberOfHolidays];
    for (ferien in ferienList) {
        [activityItems addObject:[self createCalendarEvent:ferien]];
    }
   
    NSArray *activities = @[[[NHCalendarActivity alloc] init]];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activities];
    activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo];
    [self presentViewController:activityController animated:YES completion:nil];
    
}

-(NHCalendarEvent *)createCalendarEvent:(Ferien *)forHolidays {
    NHCalendarEvent *calendarEvent = [[NHCalendarEvent alloc] init];    
    calendarEvent.title = [forHolidays valueForKey:@"ferienName"];
    calendarEvent.startDate = [forHolidays valueForKey:@"beginn"];
    calendarEvent.endDate = [forHolidays valueForKey:@"ende"];
    calendarEvent.allDay = NO;
    
    return calendarEvent;
}

/*- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        
        if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    Ferien *ferien = [[Ferien alloc] init];
                    NSArray *ferienList = [ferien getNumberOfHolidays];
                    NSError *error;
                    for (ferien in ferienList) {
                        NSPredicate *predicateForEventsOnHolidayDate = [eventStore predicateForEventsWithStartDate:[ferien valueForKey:@"beginn"] endDate:[ferien valueForKey:@"ende"] calendars:nil]; // nil will search through all calendars
                        
                        NSArray *eventsOnHolidayDate = [eventStore eventsMatchingPredicate:predicateForEventsOnHolidayDate];
                        
                        BOOL eventExists = NO;
                        
                        for (EKEvent *eventToCheck in eventsOnHolidayDate) {
                            if ([eventToCheck.title isEqualToString:[ferien valueForKey:@"ferienName"]]) {
                                eventExists = YES;
                            }
                        }
                        
                        if (eventExists == NO) {
                            EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                            event.calendar = [eventStore defaultCalendarForNewEvents];
                            event.allDay = YES;
                            event.title = [ferien valueForKey:@"ferienName"];
                            event.startDate = [ferien valueForKey:@"beginn"];
                            event.endDate = [ferien valueForKey:@"ende"];
                            [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
                        }
                    }
                }
            }];
        }
    }
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Ferien *ferien = [[Ferien alloc] init];
    return [[ferien getNumberOfHolidays] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    Ferien *ferien = [[Ferien alloc] init];
    id info = [[ferien getNumberOfHolidays] objectAtIndex:indexPath.row];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [info ferienName]];
    
    NSDateFormatter *formatBeginn = [[NSDateFormatter alloc] init];
    [formatBeginn setDateFormat:@"dd.MM.YY"];
    NSString *beginn = [formatBeginn stringFromDate:[info beginn]];
    
    NSDateFormatter *formatEnde = [[NSDateFormatter alloc] init];
    [formatEnde setDateFormat:@"dd.MM.YY"];
    NSString *ende = [formatEnde stringFromDate:[info ende]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", beginn, ende];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    StatsViewController *statsvc = [myStoryboard instantiateViewControllerWithIdentifier:@"statsvc"];
    
    Ferien *ferien = [[Ferien alloc] init];
    id info = [[ferien getNumberOfHolidays] objectAtIndex:indexPath.row];
    
    NSDate *startDate = [info beginn];
    NSDate *endDate = [info ende];

    statsvc.ferienName = [NSString stringWithFormat:@"%@", [info ferienName]];
    statsvc.feriendauer = [NSString stringWithFormat:@"Feriendauer: %d Tage", [ferien daysBetweenDate:startDate andDate:endDate]];
    statsvc.feriendauerTotal = [NSString stringWithFormat:@"Feriendauer/Jahr: %d Tage", [ferien getTotalDays]];
    
    [self presentViewController:statsvc animated:YES completion:nil];
}

- (void)initBundesland {
    self.label1.text = nil;
    self.label2.text = nil;

    Ferien *ferien = [[Ferien alloc] init];
    
    UILabel *labelTage = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 50, 15)];
    labelTage.text = @"Tage";
    labelTage.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];
    labelTage.textColor = [UIColor grayColor];
    labelTage.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelTage];
    
    UILabel *labelStunden = [[UILabel alloc] initWithFrame:CGRectMake(96, 8, 50, 15)];
    labelStunden.text = @"Stunden";
    labelStunden.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];
    labelStunden.textColor = [UIColor grayColor];
    labelStunden.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelStunden];
    
    UILabel *labelMinuten = [[UILabel alloc] initWithFrame:CGRectMake(170, 8, 50, 15)];
    labelMinuten.text = @"Minuten";
    labelMinuten.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];
    labelMinuten.textColor = [UIColor grayColor];
    labelMinuten.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelMinuten];
        
    UILabel *labelSekunden = [[UILabel alloc] initWithFrame:CGRectMake(243, 8, 50, 15)];
    labelSekunden.text = @"Sekunden";
    labelSekunden.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];
    labelSekunden.textColor = [UIColor grayColor];
    labelSekunden.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelSekunden];
        
    JDDateCountdownFlipView *flipView = [[JDDateCountdownFlipView alloc] initWithDayDigitCount:2];
    [self.view addSubview: flipView];
    flipView.targetDate = [ferien getDate];
    flipView.frame = CGRectMake(10, 23, 310, 100);
        
    if (ferien.holidayFlag == NO) {
        self.holidayFlag = ferien.holidayFlag;
        self.label1 = [[UILabel alloc] initWithFrame:CGRectMake (111, 66, 198, 25)];
        self.label1.text = @"bis zum Beginn der";
        self.label1.textAlignment = NSTextAlignmentCenter;
        self.label1.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
        self.label1.textColor = [UIColor grayColor];
        self.label1.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.label1];
            
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 86, 320, 60)];
        self.label2.text = [ferien holidayName];
        self.label2.textAlignment = NSTextAlignmentCenter;
        self.label2.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:40];
        self.label2.textColor = [UIColor grayColor];
        self.label2.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.label2];
    } else {
        self.holidayFlag = ferien.holidayFlag;
        self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(111, 66, 198, 25)];
        self.label1.text = @"bis zum Ende der";
        self.label1.textAlignment = NSTextAlignmentCenter;
        self.label1.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
        self.label1.textColor = [UIColor grayColor];
        self.label1.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.label1];
            
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 86, 320, 60)];
        self.label2.text = [ferien holidayName];
        self.label2.textAlignment = NSTextAlignmentCenter;
        self.label2.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:40];
        self.label2.textColor = [UIColor grayColor];
        self.label2.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.label2];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        NSString *version = [[UIDevice currentDevice] systemVersion];
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480) {
            if (self.tableView == nil) {
//                self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 150, 300, 280) style:UITableViewStyleGrouped];
                if ([version floatValue] >= 7.0)
                    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, 320, 300) style:UITableViewStyleGrouped];
                else
                    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, 320, 300) style:UITableViewStyleGrouped];
                [self.tableView setBackgroundColor:[UIColor clearColor]];
                self.tableView.delegate = self;
                self.tableView.dataSource = self;
                self.tableView.backgroundView = nil;
                self.tableView.opaque = NO;
                self.tableView.scrollEnabled = NO;
                [self.view addSubview:self.tableView];
            }
            else {
                [self.tableView reloadData];
            }
        }
        if(result.height == 568) {
            if (self.tableView == nil) {
//                self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 180, 300, 280) style:UITableViewStyleGrouped];
                if ([version floatValue] >= 7.0)
                    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, 320, 300) style:UITableViewStyleGrouped];
                else
                    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, 320, 390) style:UITableViewStyleGrouped];
                [self.tableView setBackgroundColor:[UIColor clearColor]];
                self.tableView.delegate = self;
                self.tableView.dataSource = self;
                self.tableView.backgroundView = nil;
                self.tableView.opaque = NO;
                self.tableView.scrollEnabled = NO;
                [self.view addSubview:self.tableView];
            }
            else {
                [self.tableView reloadData];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initBundesland) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initBundesland];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
