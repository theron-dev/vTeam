//
//  VTDOMElement+Control.m
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMElement+Control.h"

@implementation VTDOMElement (Control)

-(BOOL) isEnabled{
    return [[self valueForKey:@"enabled"] boolValue];
}

-(void) setEnabled:(BOOL)enabled{
    [self setValue:[NSNumber numberWithBool:enabled] forKey:@"enabled"];
}

-(BOOL) isSelected{
    return [[self valueForKey:@"selected"] boolValue];
}

-(void) setSelected:(BOOL)selected{
    [self setValue:[NSNumber numberWithBool:selected] forKey:@"selected"];
}

-(BOOL) isHighlighted{
    return [[self valueForKey:@"highlighted"] boolValue];
}

-(void) setHighlighted:(BOOL)highlighted{
    [self setValue:[NSNumber numberWithBool:highlighted] forKey:@"highlighted"];
}

- (BOOL)touchesBegan:(CGPoint) location{
    CGSize size = self.frame.size;
    if(location.x >=0 && location.y >=0 && location.x < size.width && location.y < size.height){
        [self setHighlighted:YES];
    }
    return NO;
}

- (void)touchesMoved:(CGPoint) location{
    CGSize size = self.frame.size;
    if(location.x < 0 || location.y < 0 || location.x >= size.width || location.y >= size.height){
        [self setHighlighted:NO];
    }
}

- (void)touchesEnded:(CGPoint) location{
    [self setHighlighted:NO];
}

- (void)touchesCancelled:(CGPoint) location{
    [self setHighlighted:NO];
}

@end
