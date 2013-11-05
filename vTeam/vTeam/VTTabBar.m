//
//  VTTabBar.m
//  vTeam
//
//  Created by zhang hailong on 13-7-5.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTabBar.h"

@implementation VTTabBar

@synthesize backgroundImage = _backgroundImage;

-(void) dealloc{
    [_backgroundImage release];
    [super dealloc];
}


-(void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    if(_backgroundImage){
        [_backgroundImage drawInRect:rect];
    }
}


-(void) setBackgroundImage:(UIImage *)backgroundImage{
    if(_backgroundImage != backgroundImage){
        [_backgroundImage release];
        _backgroundImage = [backgroundImage retain];
        [self setNeedsDisplay];
    }
}

-(NSUInteger) selectedIndex{
    return [[self items] indexOfObject:self.selectedItem];
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex{
    if(selectedIndex < [self.items count]){
        [self setSelectedItem:[self.items objectAtIndex:selectedIndex]];
    }
}
    
@end
