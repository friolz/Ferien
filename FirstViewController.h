//
//  FirstViewController.h
//  FerienCountdown
//
//  Created by Tobi on 06.03.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) IBOutlet UILabel *bundeslandLabel;
@property (nonatomic, retain) IBOutlet UIImageView *bundeslandImage;
@property (nonatomic, retain) IBOutlet UIImageView *countdownImage;
@property (nonatomic, retain) IBOutlet UIImageView *countdownSentence;
@property (nonatomic, retain) IBOutlet UIImageView *currentHolidays;

@end
