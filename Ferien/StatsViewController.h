//
//  StatsViewController.h
//  Ferien
//
//  Created by Tobi on 02.02.13.
//  Copyright (c) 2013 Tobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ferien.h"
#import "CorePlot-CocoaTouch.h"

@interface StatsViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (nonatomic, copy) NSString *ferienName;
@property (nonatomic, copy) NSString *feriendauer;
@property (nonatomic, copy) NSString *feriendauerTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelFerienName;
@property (weak, nonatomic) IBOutlet UILabel *labelFeriendauer;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)dismiss:(id)sender;

@end
