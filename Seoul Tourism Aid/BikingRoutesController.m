//
//  BikingRoutesController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BikingRoutesController.h"
#import "BikeRouteMapController.h"

@interface BikingRoutesController ()

@property NSMutableDictionary<NSNumber*,MKPolyline*>* bikeRouteDictionary;
@property BIKE_ROUTES selectedBikeRoute;



@end


@implementation BikingRoutesController

-(void)viewWillAppear:(BOOL)animated{
    
    [self loadBikeRouteDictionary];
}


-(void)viewDidLoad{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BikeRouteCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return LAST_ROUTE_INDEX;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"BikeRouteCell"];
    
    NSString* routeTitle = [self getRouteNameForBikeRouteEnum:indexPath.row];
    
    [cell.textLabel setText:routeTitle];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedBikeRoute = (BIKE_ROUTES)indexPath.row;
    
    [self performSegueWithIdentifier:@"showBikeRouteMapSegue" sender:nil];
}

-(NSString*)getRouteNameForBikeRouteEnum:(BIKE_ROUTES)bikeRoute{
    
    switch (bikeRoute) {
        case GONGDEOK_HYOCHANG_ROUTE:
            return @"Gongdeok-Hyochang Park Bike Route";
            break;
        case GONGDEOK_SEOGANG_ROUTE:
            return @"Gongdeok-Seogang Walking/Biking Route";
        case NATIONAL_SECURITY_PAVILION_PATH:
            return @"National Security Pavilion Path (Korean War Memorial)";
        case KOREAN_WAR_EXHIBIT_ROOM_1:
            return @"Korean War Exhibit Room 1";
        case KOREAN_WAR_EXHIBIT_ROOM_2:
            return @"Korean War Exhibit Room 2";
        case KOREAN_WAR_EXHIBIT_ROOM_3:
            return @"Korean War Exhibit Room 3";
        case DONATED_RELICS_EXHIBIT:
            return @"Donated Relics Exhibit";
        case ROK_ARMED_FORCES_ROOM:
            return @"ROK Armed Forces Room";
        case WAR_HISTORY_EXHIBIT_ROOM_1:
            return @"War History Exhibit Room 1";
        case WAR_HISTORY_EXHIBIT_ROOM_2:
            return @"War History Exhibit Room 2";
        default:
            return nil;
    }
    
}

-(void) loadBikeRouteDictionary{
    
    self.bikeRouteDictionary = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < LAST_ROUTE_INDEX; i++) {
        
        NSNumber* numberIndex = [NSNumber numberWithInt:i];
        
        BIKE_ROUTES bikeRoute = (BIKE_ROUTES)i;
        
        MKPolyline* bikeRoutePolyline = [self getbikeRoutePolylineFor:bikeRoute];
        
        
        [self.bikeRouteDictionary setObject:bikeRoutePolyline forKey:numberIndex];
        
    }
}

-(MKPolyline*)getbikeRoutePolylineFor:(BIKE_ROUTES)bikeRoute{
    
    NSString* filePath;
    
    switch (bikeRoute) {
        case GONGDEOK_HYOCHANG_ROUTE:
            filePath = [[NSBundle mainBundle] pathForResource:@"path1" ofType:@"plist"];
            break;
        case GONGDEOK_SEOGANG_ROUTE:
            filePath = [[NSBundle mainBundle] pathForResource:@"path2" ofType:@"plist"];
            break;
        case NATIONAL_SECURITY_PAVILION_PATH:
            filePath = [[NSBundle mainBundle] pathForResource:@"NationalSecurityPavilionPath" ofType:@"plist"];
            break;
        case KOREAN_WAR_EXHIBIT_ROOM_1:
            filePath = [[NSBundle mainBundle] pathForResource:@"KoreanWarExhibitRoom1" ofType:@"plist"];
            break;
        
        case KOREAN_WAR_EXHIBIT_ROOM_2:
            filePath = [[NSBundle mainBundle] pathForResource:@"KoreanWarExhibitRoom2" ofType:@"plist"];
            break;
        case KOREAN_WAR_EXHIBIT_ROOM_3:
            filePath = [[NSBundle mainBundle] pathForResource:@"KoreanWarExhibitRoom3" ofType:@"plist"];
            break;
        case WAR_HISTORY_EXHIBIT_ROOM_1:
            filePath = [[NSBundle mainBundle] pathForResource:@"WarHistoryExhibit" ofType:@"plist"];
            break;
        case WAR_HISTORY_EXHIBIT_ROOM_2:
            filePath = [[NSBundle mainBundle] pathForResource:@"WarHistoryExhibit2" ofType:@"plist"];
            break;
        case DONATED_RELICS_EXHIBIT:
            filePath = [[NSBundle mainBundle] pathForResource:@"DonatedRelicsExhibit" ofType:@"plist"];
            break;
        case ROK_ARMED_FORCES_ROOM:
            filePath = [[NSBundle mainBundle] pathForResource:@"ROKArmedForcesRoom" ofType:@"plist"];
            break;
        default:
            break;
    }
    
    if(!filePath){
        NSLog(@"Filepath could not be loaded for bike route");
        return nil;
    }
    
    NSArray* pointsArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSInteger pointsCount = [pointsArray count];
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for (int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x, p.y);
    }
    
    return [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showBikeRouteMapSegue"]){
        
        NSLog(@"Preparing segue...");
        
        NSNumber* selectedNumberIndex = [NSNumber numberWithInt:self.selectedBikeRoute];
        
        MKPolyline* polyline = [self.bikeRouteDictionary objectForKey:selectedNumberIndex];
        
        NSLog(@"Retrieved polyline from dictionary: %@",[polyline description]);
        
         BikeRouteMapController* bikeRouteMapController = (BikeRouteMapController*)segue.destinationViewController;
        
        bikeRouteMapController.bikeRoute = polyline;
        
        bikeRouteMapController.routeName = [self getRouteNameForBikeRouteEnum:self.selectedBikeRoute];
        
        
        
        
    }
}



@end
