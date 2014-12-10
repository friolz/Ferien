//
//  SettingsViewController.h
//  Ferien
//
//  Created by Tobi on 10.01.13.
//  Copyright (c) 2013 Tobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ferien.h"

@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) UIImageView *bundeslandImage;

- (IBAction)dismiss:(id)sender;

@end
