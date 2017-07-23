//
//  PolygonSelectionController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PolygonSelectionController.h"
#import "PolygonMapController.h"
#import "BoundaryOverlay.h"
//#import "DLinkedList.h"


@interface PolygonSelectionController ()

@property NSMutableDictionary* polygonDictionary;
@property POLYGON_TYPE currentlySelectedPolygonIndex;

@end

@implementation PolygonSelectionController


-(void)viewDidLoad{
    
    [self loadPolygonDictionary];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PolygonCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return LAST_POLYGON_INDEX;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PolygonCell"];
    
    NSString* title = [self getCellTitleForPolygonEnum:(POLYGON_TYPE)indexPath.row];
    
    [cell.textLabel setText:title];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentlySelectedPolygonIndex = (POLYGON_TYPE)indexPath.row;
    
    [self performSegueWithIdentifier:@"showPolygonMapControllerSegue" sender:nil];
}

-(NSString*)getCellTitleForPolygonEnum:(POLYGON_TYPE)polygonType{
    switch (polygonType) {
        case LOTTO_HOTEL:
            return @"Lotto Hotel";
        case KOREAN_WAR_MEMORIAL:
            return @"Korean War Memorial (Main Building)";
        case PETRAEUS_BUILDING:
            return @"Petraeus Building Complex";
        case GUANGHUAMUN:
            return @"Guanghuamun and Gyeongbok Palace";
        case NATIONAL_PALACE_MUSEUM:
            return @"National Palace Museum";
        case WORLD_CUP_STADIUM:
            return @"World Cup Stadium (Perimeter)";
        default:
            return nil;
    }
}


-(void)loadPolygonDictionary{
 
    self.polygonDictionary = [[NSMutableDictionary alloc] init];
    
    for(int i = 0; i < LAST_POLYGON_INDEX; i++){
        
        NSNumber* numberIndex = [NSNumber numberWithInteger:i];
        
        POLYGON_TYPE polygonType = (POLYGON_TYPE)i;
        
        NSString* fileName;
        
        switch (polygonType) {
            case LOTTO_HOTEL:
                fileName = @"LottoHotel";
                break;
            case KOREAN_WAR_MEMORIAL:
                fileName = @"WarMemorialMainBuilding";
                break;
            case PETRAEUS_BUILDING:
                fileName = @"PetraeusBuilding";
                break;
            case GUANGHUAMUN:
                fileName = @"Gwanghuamun";
                break;
            case NATIONAL_PALACE_MUSEUM:
                fileName = @"NationalPalaceMuseum";
                break;
            case WORLD_CUP_STADIUM:
                fileName = @"WorldCupStadium";
                break;
            default:
                break;
        }
        
        
        NSLog(@"Preparing to initialize boundary overaly with path %@",fileName);
        
        BoundaryOverlay* polygonOverlay = [[BoundaryOverlay alloc] initWithFilename:fileName];
        
        //Create Doubly-Linked List here
        /**
        DLinkedList* linkedList = [[DLinkedList alloc] initWithFileType2:fileName];
        
        [linkedList traverseListWithFunction:^(DLinkedNode* node){
        
            NSLog(@"Traversed node %@, with coordinates lat: %f, long: %f",[node name], [node coordinate].latitude, [node coordinate].longitude);
        
        }];
        
        **/
        
        [self.polygonDictionary setObject:polygonOverlay forKey:numberIndex];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"showPolygonMapControllerSegue"]){
        
        PolygonMapController* polygonMapController = (PolygonMapController*)segue.destinationViewController;
        
        BoundaryOverlay* currentPolygon = [self.polygonDictionary objectForKey:[NSNumber numberWithInteger:self.currentlySelectedPolygonIndex]];
        
        polygonMapController.polygonOverlay = currentPolygon;
    }
}

@end
