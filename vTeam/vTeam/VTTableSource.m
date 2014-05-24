//
//  VTTableSource.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTableSource.h"

@implementation VTTableSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_sections objectAtIndex:section] cells] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[[_sections objectAtIndex:indexPath.section] cells] objectAtIndex:indexPath.row];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_sections objectAtIndex:section] title];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    id item = [_sections objectAtIndex:section];
    UIView * view = [item view];
    if(view){
        return view.frame.size.height;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIView * v = [[[_sections objectAtIndex:indexPath.section] cells] objectAtIndex:indexPath.row];
    
    return v.frame.size.height;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[_sections objectAtIndex:section] view];
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[_sections objectAtIndex:section] footerView];
}
    
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    id item = [_sections objectAtIndex:section];
    UIView * view = [item footerView];
    if(view){
        return view.frame.size.height;
    }
    return 0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id delegate = [self delegate];
    
    if([delegate respondsToSelector:@selector(vtTableSource:tableView:didSelectRowAtIndexPath:)]){
        [delegate vtTableSource:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}

@end
