//
//  VTTableDataController.m
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTableDataController.h"

@implementation VTTableDataController

@synthesize tableView = _tableView;
@synthesize itemViewNib = _itemViewNib;
@synthesize itemViewClass = _itemViewClass;
@synthesize itemViewBundle = _itemViewBundle;

-(void) dealloc{
    [_tableView setDelegate:nil];
    [_itemViewNib release];
    [_tableView release];
    [_itemViewClass release];
    [_itemViewBundle release];
    [super dealloc];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataSource dataObjects] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VTTableViewCell * cell = (VTTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"VTTableViewCell"];
    
    if(cell == nil){
        
        Class clazz = NSClassFromString(_itemViewClass);
        
        if(clazz == nil){
            clazz = [VTTableViewCell class];
        }
        
        cell = [[[clazz alloc] initWithNibName:_itemViewNib bundle:_itemViewBundle reuseIdentifier:@"VTTableViewCell"] autorelease];
        [cell setDelegate:self];
        
    }
    
    id data = [self.dataSource dataObjectAtIndex:indexPath.row];
  
    [cell setContext:self.context];
    
    [cell setDataItem:data];
    
    return cell;
}

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
    [super vtDataSourceDidLoadedFromCache:dataSource timestamp:timestamp];
    [_tableView reloadData];
}

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    [super vtDataSourceDidLoaded:dataSource];
    [_tableView reloadData];
}

@end
