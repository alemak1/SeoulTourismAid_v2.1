//
//  TouristLocationParentController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/5/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristLocationParentController.h"
#import "TouristLocationTableViewController.h"
#import "AnnotationMapViewController.h"



@interface TouristLocationParentController ()


- (IBAction)toggleDescriptionDetail:(UIBarButtonItem *)sender;



- (IBAction)viewAnnotationsInMaps:(UIBarButtonItem *)sender;




@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleDescriptionButton;


@property (readonly) TouristLocationTableViewController* touristLocationTableViewController;

@end




@implementation TouristLocationParentController


-(void)viewWillAppear:(BOOL)animated{
    [self addObserver:self forKeyPath:@"touristLocationTableViewController" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [self removeObserver:self forKeyPath:@"touristLocationTableViewController"];

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"touristLocationTableViewController"]){
        
        TouristLocationTableViewController*tbController = (TouristLocationTableViewController*)[self.childViewControllers firstObject];
        
        tbController.annotationFilePath = self.annotationFilePath;
        
        [tbController.tableView reloadData];

        
    }
}

-(void)viewDidLoad{
    
    
}
    


- (IBAction)toggleDescriptionDetail:(UIBarButtonItem *)sender {
    
    [self.touristLocationTableViewController reloadTableViewToShowAddresses];
    
    
    if(self.touristLocationTableViewController.canOnlySeeNameForTableViewCells){
        
        [self.toggleDescriptionButton setTitle:@"See Full Description"];

    } else {
        
        [self.toggleDescriptionButton setTitle:@"See Name Only"];

    }
    
}

- (IBAction)viewAnnotationsInMaps:(UIBarButtonItem *)sender {
    
    if([self.touristLocationTableViewController getUserSelectedAnnotation] == nil){
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No Location Selected" message:@"Please select a location from the table below in order to view it's position in Maps" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okay];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
    
    [self performSegueWithIdentifier:@"showAnnotationMapViewControllerSegue" sender:nil];
        
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showAnnotationMapViewControllerSegue"]){
        //Add selected annotations from child tableview controller to the destination controller's map view
        
        SeoulLocationAnnotation* selectedAnnotation = [self.touristLocationTableViewController getUserSelectedAnnotation];
        
        AnnotationMapViewController* annotationMapViewController = (AnnotationMapViewController*)segue.destinationViewController;
        
        annotationMapViewController.annotation = selectedAnnotation;
        
    }
}


-(TouristLocationTableViewController *)touristLocationTableViewController{
    
    TouristLocationTableViewController* touristLocationTableViewController = [self.childViewControllers firstObject];
    
    return touristLocationTableViewController;
}



@end
