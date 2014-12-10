//
//  FirstViewController.m
//  FerienCountdown
//
//  Created by Tobi on 06.03.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import "FirstViewController.h"
#import "Ferien.h"


@implementation FirstViewController

@synthesize background, bundeslandLabel, bundeslandImage, countdownImage, countdownSentence, currentHolidays;

- (void)reloadUI {
    Ferien *ferien = [[Ferien alloc] init];
    [countdownImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", [ferien calculateDaysToNextHolidays]]]];
    if (ferien.holidayFlag == NO) {
        [countdownSentence setImage:[UIImage imageNamed:@"biszuden.png"]];
        [currentHolidays setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [ferien holidayName]]]];
    }
    
    else {
        [countdownSentence setImage:[UIImage imageNamed:@"biszumendeder.png"]];
        [currentHolidays setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [ferien holidayName]]]];
    }
    [ferien release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [background setImage:[UIImage imageNamed:@"background1.png"]];
    
    // Make the app update when switching to foreground
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    Ferien *ferien = [[Ferien alloc] init];
    
    bundeslandLabel.text = [ferien formattedBundeslandFromArray];
    NSString *lowerCaseBundesland = [[ferien bundeslandFromArray] lowercaseString];
    [bundeslandImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", lowerCaseBundesland]]];
    [countdownImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", [ferien calculateDaysToNextHolidays]]]];
    if (ferien.holidayFlag == NO) {
        [countdownSentence setImage:[UIImage imageNamed:@"biszuden.png"]];
        [currentHolidays setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [ferien holidayName]]]];
    }
    
    else {
        [countdownSentence setImage:[UIImage imageNamed:@"biszumendeder.png"]];
        [currentHolidays setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [ferien holidayName]]]];
    }

    [ferien release];

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) releaseOutlets {
    self.background = nil;
    self.bundeslandLabel = nil;
    self.bundeslandImage = nil;
    self.countdownImage = nil;
    self.countdownSentence = nil;
    self.currentHolidays = nil;
}

- (void)viewDidUnload {
    [self releaseOutlets];
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseOutlets];
    [super dealloc];
}

@end
