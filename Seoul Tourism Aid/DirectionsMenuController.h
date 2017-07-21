//
//  DirectionsMenuController.h
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef DirectionsMenuController_h
#define DirectionsMenuController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DirectionsMenuController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerControl;




@end

#endif /* DirectionsMenuController_h */
