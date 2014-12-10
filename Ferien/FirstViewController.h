//
//  FirstViewController.h
//  Ferien
//
//  Created by Tobi on 10.01.13.
//  Copyright (c) 2013 Tobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ferien.h"
#import "JDFlipNumberView.h"
#import "JDDateCountdownFlipView.h"
#import <EventKit/EventKit.h>
#import "StatsViewController.h"
#import "NHCalendarActivity.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) NSMutableArray *arrayofEventId;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic) BOOL holidayFlag;

- (IBAction)calendar:(id)sender;

@end
