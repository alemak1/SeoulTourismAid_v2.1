//
//  AcknowledgementsVC.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "AcknowledgementsVC.h"
#import "AuthorPicCell.h"
#import "TouristSiteSectionHeaderCell.h"

@interface AcknowledgementsVC ()

@property (readonly) NSDictionary* plistDict;

@end


@implementation AcknowledgementsVC

@synthesize plistDict = _plistDict;

-(void)viewDidLoad{
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return NUMBER_OF_AUTHORS;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    AUTHOR author = (AUTHOR)section;
    
    return [[self getImgPathArrayForAuthor:author] count];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    TouristSiteSectionHeaderCell* headerView;
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AcknolwedgementsHeaderCell" forIndexPath:indexPath];
        
        AUTHOR author = (AUTHOR)indexPath.section;
        
        
        headerView.titleText = [self getStringForAuthor:author];
        
    }
    
    return headerView;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthorPicCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AuthorPicCell" forIndexPath:indexPath];
    
    NSString* imagePath = [self getImgPathForIndexPath:indexPath];
    
    cell.authorPic = [UIImage imageNamed:imagePath];
    
    return cell;
}

-(NSString*)getImgPathForIndexPath:(NSIndexPath*)indexPath{
    
    AUTHOR author = (AUTHOR)indexPath.section;
    
    NSArray* imgPathArray = [self getImgPathArrayForAuthor:author];
    
    return [imgPathArray objectAtIndex:indexPath.row];
    
}


-(NSArray*)getImgPathArrayForAuthor:(AUTHOR)author{
    NSString* authorString = [self getStringForAuthor:author];
    
    NSArray* imgPathArray = self.plistDict[authorString];
    
    return imgPathArray;
}

-(NSString*)getStringForAuthor:(AUTHOR)author{
    switch (author) {
        case FREEPIK:
            return @"Freepik";
        case NIKITA_GOLUBEV:
            return @"Nikita Golubev";
        case ALFREDO_HERNANDEZ:
            return @"Alfredo Hernandez";
        case OLIVER:
            return @"Oliver";
        case DINOSOFT_LABS:
            return @"DinosoftLabs";
        case VECTORS_MARKET:
            return @"Vectors Market";
        case ROUNDICONS:
            return @"Roundicons";
        case GRAPHBERRY:
            return @"Graphberry";
        case ZLATKO_NAJDENOVKSI:
            return @"Zlatko Najdenovski";
        case YANNICK:
            return @"Yannick";
        case ICONNICE:
            return @"Iconnice";
        case ICON_POND:
            return @"Icon Pond";
        case SWIFTICONS:
            return @"Swifticons";
        case PIXEL_BUDDHA:
            return @"Pixel Buddha";
        default:
            break;
    }
    
    return nil;
}

-(NSDictionary *)plistDict{
    
    if(_plistDict == nil){
        NSString* path = [[NSBundle mainBundle] pathForResource:@"IconAcknowledgements" ofType:@"plist"];
        
        _plistDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return _plistDict;
    
}

@end
