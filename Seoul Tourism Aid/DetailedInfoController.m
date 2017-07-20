//
//  DetailedInfoController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/20/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "DetailedInfoController.h"


@interface DetailedInfoController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIStackView *vStackView;

- (IBAction)dismissDetailedInfoController:(UIButton *)sender;

@end


@implementation DetailedInfoController

-(void)viewDidLoad{
    [self.titleLabel setText:self.titleText];
    
    for (NSString*detailString in self.detailStringList) {
        
        UILabel* stringLabel = [[UILabel alloc] init];
        [stringLabel setText:detailString];
        
        [self.vStackView addArrangedSubview:stringLabel];
        
    }
    
}

- (IBAction)dismissDetailedInfoController:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
