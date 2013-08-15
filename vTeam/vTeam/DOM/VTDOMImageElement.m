//
//  VTDOMImageElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMImageElement.h"

#import "VTDOMElement+Render.h"
#import "VTDOMElement+Style.h"
#import "VTDOMDocument.h"

#import <QuartzCore/QuartzCore.h>

@implementation VTDOMImageElement

@synthesize image = _image;

-(void) dealloc{
    [_image release];
    [super dealloc];
}

-(UIImage *) image{
    if(_image == nil){
        self.image = [self imageValueForKey:@"src" bundle:self.document.bundle];
    }
    return _image;
}

-(void) draw:(CGRect) rect context:(CGContextRef) context{
    
    [super draw:rect context:context];
    
    CGSize size = self.frame.size;
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    
    UIImage * image = [self image];
    
    if(image ){
        
        CALayer * layer = [[[CALayer alloc] init] autorelease];
        layer.frame = r;
        layer.contents = (id)[image CGImage];
        layer.contentsRect = CGRectMake(0, 0, 1.0, 1.0);
        
        NSString * gravity = [self stringValueForKey:@"gravity"];
        
        if([gravity isEqualToString:@"center"]){
            layer.contentsGravity = kCAGravityCenter;
        }
        else if([gravity isEqualToString:@"resize"]){
            layer.contentsGravity = kCAGravityResize;
        }
        else if([gravity isEqualToString:@"top"]){
            layer.contentsGravity = kCAGravityTop;
        }
        else if([gravity isEqualToString:@"bottom"]){
            layer.contentsGravity = kCAGravityBottom;
        }
        else if([gravity isEqualToString:@"left"]){
            layer.contentsGravity = kCAGravityLeft;
        }
        else if([gravity isEqualToString:@"right"]){
            layer.contentsGravity = kCAGravityRight;
        }
        else if([gravity isEqualToString:@"topleft"]){
            layer.contentsGravity = kCAGravityTopLeft;
        }
        else if([gravity isEqualToString:@"topright"]){
            layer.contentsGravity = kCAGravityTopRight;
        }
        else if([gravity isEqualToString:@"bottomleft"]){
            layer.contentsGravity = kCAGravityBottomLeft;
        }
        else if([gravity isEqualToString:@"bottomright"]){
            layer.contentsGravity = kCAGravityBottomRight;
        }
        else if([gravity isEqualToString:@"aspect"]){
            layer.contentsGravity = kCAGravityResizeAspect;
        }
        else{
            layer.contentsGravity = kCAGravityResizeAspectFill;
        }
        
        [layer renderInContext:context];
    }
    
}


@end
