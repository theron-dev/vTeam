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
#import "VTDOMElement+Layout.h"
#import "VTDOMDocument.h"

#import <QuartzCore/QuartzCore.h>

@interface VTDOMImageElement()


@end

@implementation VTDOMImageElement

@synthesize image = _image;

@synthesize source = _source;
@synthesize loading = _loading;
@synthesize defaultImage = _defaultImage;
@synthesize loaded = _loaded;

-(void) dealloc{
    [_defaultImage release];
    [_image release];
    [super dealloc];
}

-(UIImage *) image{
    if(_image == nil){
        self.image = [VTDOMStyle imageValue:[self src] bundle:self.document.bundle];
    }
    return _image;
}

-(UIImage *) defaultImage{
    if(_defaultImage == nil){
        self.defaultImage = [VTDOMStyle imageValue:[self defaultSrc] bundle:self.document.bundle];
    }
    return _defaultImage;
}

-(NSString *) src{
    
    NSString * src = [self attributeValueForKey:@"src"];
    
    if(src && ![src hasPrefix:@"@"] && self.document.documentURL){
        return [[NSURL URLWithString:src relativeToURL:self.document.documentURL] absoluteString];
    }
    
    return src;
}

-(void) setAttributeValue:(NSString *)value forKey:(NSString *)key{
    [super setAttributeValue:value forKey:key];
    if([key isEqualToString:@"src"]){
        _loaded = NO;
        _loading = NO;
        self.image = nil;
    }
}

-(void) setSrc:(NSString *)src{
    [self setAttributeValue:src forKey:@"src"];
}

-(NSString *) defaultSrc{
    
    NSString * src = [self attributeValueForKey:@"defaultSrc"];
    
    if(src == nil){
        src = [self attributeValueForKey:@"default-src"];
    }
    
    if(src && ![src hasPrefix:@"@"] && self.document.documentURL){
        return [[NSURL URLWithString:src relativeToURL:self.document.documentURL] absoluteString];
    }
    
    return src;
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
    
    if(image){
        
        if([self attributeValueForKey:@"fit-width"]){
            
            CGRect r = [self frame];
            
            CGSize imageSize = [image size];
            
            if(r.size.width && r.size.height && imageSize.width && imageSize.height){
                
                if(r.size.width / r.size.height != imageSize.width / imageSize.height){
                    r.size.width = imageSize.width / imageSize.height * r.size.height;
                    
                    [self setFrame:r];
                }
                
            }
            
        }
        
        if([self attributeValueForKey:@"fit-height"]){
            
            CGRect r = [self frame];
            
            CGSize imageSize = [image size];
            
            if(r.size.width && r.size.height && imageSize.width && imageSize.height){
                
                if(r.size.width / r.size.height != imageSize.width / imageSize.height){
                    
                    r.size.height = imageSize.height / imageSize.width * r.size.width;
                    
                    [self setFrame:r];
                }
                
            }
            
        }
    }
    
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
        
        CALayer * layer = [self layer];
        layer.frame = r;
        layer.contents = (id)[image CGImage];
        layer.contentsCenter = CGRectMake(0, 0, 1, 1);
        layer.contentsScale = [image scale];
        
        CGSize imageSize = [image size];
        CGFloat leftCapWidth = [image leftCapWidth];
        CGFloat topCapHeight = [image topCapHeight];
        
        if(leftCapWidth || topCapHeight){
            
            leftCapWidth = leftCapWidth / imageSize.width;
            topCapHeight = topCapHeight / imageSize.height;
            
            layer.contentsCenter = CGRectMake(leftCapWidth, topCapHeight, 1.0 / imageSize.width , 1.0 / imageSize.height);
        }
        
        UIEdgeInsets padding = [self padding];
        
        layer.contentsRect = CGRectMake(padding.left / imageSize.width, padding.top / imageSize.height
                                        , 1.0 - (padding.left + padding.right) / imageSize.width
                                        , 1.0 - (padding.top + padding.bottom) / imageSize.height);

        
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

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    CGRect r = [self frame];
    
    if(r.size.width == MAXFLOAT || r.size.height == MAXFLOAT){
        
        UIImage * image = [self image];
        
        if(image){
            
            CGSize s = image.size;
            
            if(r.size.width == MAXFLOAT){
                r.size.width = s.width;
            }
            
            if(r.size.height == MAXFLOAT){
                r.size.height = s.height;
            }

        }
        else{
            if(r.size.width == MAXFLOAT){
                r.size.width = 0;
            }
            
            if(r.size.height == MAXFLOAT){
                r.size.height = 0;
            }
        }
       
        [self setFrame:r];
        
    }
    return r.size;
}

-(BOOL) isPreload{
    return [self booleanValueForKey:@"preload"];
}

@end
