//
//  EntryViewControllerPad.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntryViewControllerPad.h"
#import "SKViewCell.h"

@implementation EntryViewControllerPad

-(void)viewDidLoad{
    
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return TOTAL_NUMBER_OF_SCENES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SKViewCell* skViewCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SKViewCell" forIndexPath:indexPath];
    
    SCENE_OPTION scene_option = (SCENE_OPTION)indexPath.row;
    
    [skViewCell setSceneOption:scene_option];
    
    return skViewCell;
}

@end
