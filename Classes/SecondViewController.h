//
//  SecondViewController.h
//  FerienCountdown
//
//  Created by Tobi on 06.03.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface SecondViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
}

@property (nonatomic, retain) IBOutlet UIImageView *background;

- (IBAction)addtoCal:(id)sender;

@end
