//
//  VTDOMElement+Render.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMElement+Render.h"
#import "VTDOMElement+Style.h"
#import "VTDOMDocument.h"
#import <QuartzCore/QuartzCore.h>

@implementation VTDOMElement (Render)

-(void) render:(CGRect) rect context:(CGContextRef) context{
    
    [self draw:rect context:context];
    
    for(VTDOMElement * element in [self childs]){
        
        CGRect frame = [element frame];
        
        CGRect r = CGRectIntersection(frame, rect);
        
        if(r.size.width >0 && r.size.height >0){
            
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, r.origin.x, r.origin.y);
            
            CGContextClipToRect(context, CGRectMake(0, 0, r.size.width, r.size.height) );
            
            [element render:CGRectMake(0, 0, r.size.width, r.size.height) context:context];
            
            CGContextRestoreGState(context);
            
        }
        
    }
    
}

-(void) draw:(CGRect) rect context:(CGContextRef) context{
    
    CGSize size = self.frame.size;
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    
    UIColor * backgroundColor = [self colorValueForKey:@"background-color"];
    
    if(backgroundColor){
        
        CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
        CGContextSetStrokeColorWithColor(context, [backgroundColor CGColor]);
        
        CGContextFillRect(context, r);
        
    }

    UIImage * backgroundImage = [self imageValueForKey:@"background-image" bundle:self.document.bundle];
    
    if(backgroundImage ){
        
        CGSize imageSize = backgroundImage.size;
        CGFloat left = backgroundImage.leftCapWidth / imageSize.width;
        CGFloat top = backgroundImage.topCapHeight / imageSize.height;
        
        if(left && top){
            static CALayer * bgLayer = nil;
            if(bgLayer == nil){
                bgLayer = [[CALayer alloc] init];
            }
            bgLayer.frame = r;
            bgLayer.contents = (id)[backgroundImage CGImage];
            bgLayer.contentsScale = [backgroundImage scale];
            bgLayer.contentsCenter  = CGRectMake(left, top, 1.0 / imageSize.width, 1.0 / imageSize.height);
            
            [bgLayer renderInContext:context];
        }
        else{
            [backgroundImage drawInRect:r];
        }

    }

}

@end
