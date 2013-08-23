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

@synthesize source = _source;
@synthesize httpTask = _httpTask;
@synthesize defaultImage = _defaultImage;
@synthesize loaded = _loaded;

-(void) dealloc{
    [_httpTask release];
    [_defaultImage release];
    [_image release];
    [super dealloc];
}

-(UIImage *) image{
    if(_image == nil){
        self.image = [self imageValueForKey:@"src" bundle:self.document.bundle];
    }
    return _image;
}

-(UIImage *) defaultImage{
    if(_defaultImage == nil){
        self.defaultImage = [self imageValueForKey:@"defaultSrc" bundle:self.document.bundle];
    }
    return _defaultImage;
}

-(NSString *) src{
    return [self attributeValueForKey:@"src"];
}

-(void) setSrc:(NSString *)src{
    [self setAttributeValue:src forKey:@"src"];
}

-(NSString *) defaultSrc{
    return [self attributeValueForKey:@"defaultSrc"];
}

-(void) setDefaultSrc:(NSString *)defaultSrc{
    [self setAttributeValue:defaultSrc forKey:@"defaultSrc"];
}

-(void) setImage:(UIImage *) image isLocal:(BOOL) isLocal{
    
    if(image == nil){
        if(!isLocal){
            self.loaded = YES;
        }
    }
    else{
        self.loaded = YES;
    }
    
    self.image = image;
    
    [self setNeedDisplay];
}

-(void) draw:(CGRect) rect context:(CGContextRef) context{
    
    [super draw:rect context:context];
    
    CGSize size = self.frame.size;
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    
    UIImage * image = [self image];
    
    if(image == nil){
        image = [self defaultImage];
    }
    
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
