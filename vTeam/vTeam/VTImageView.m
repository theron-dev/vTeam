//
//  VTImageView.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTImageView.h"

#import <QuartzCore/QuartzCore.h>

@implementation VTImageView

@synthesize src = _src;
@synthesize source = _source;
@synthesize loading = _loading;
@synthesize defaultImage = _defaultImage;
@synthesize loaded = _loaded;
@synthesize defaultSrc = _defaultSrc;
@synthesize imageMode = _imageMode;
@synthesize reuseFileURI = _reuseFileURI;

-(void) dealloc{
    [_src release];
    [_defaultImage release];
    [_defaultSrc release];
    [_imageMode release];
    [_reuseFileURI release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) setImage:(UIImage *)image{
    [self setImage:image isLocal:NO];
}

-(void) setImage:(UIImage *) image isLocal:(BOOL) isLocal{
    if(image == nil){
        if(!isLocal){
            self.loaded = YES;
        }
        [super setImage:_defaultImage];
    }
    else{
        self.loaded = YES;
        [super setImage:image];
    }
}

-(void) setDefaultImage:(UIImage *)defaultImage{
    if(_defaultImage != defaultImage){
        if([self image] == _defaultImage){
            [super setImage:nil];
        }
        [_defaultImage release];
        _defaultImage = [defaultImage retain];
        if(self.image == nil){
            [super setImage:_defaultImage];
        }
    }
}

-(void) setSrc:(NSString *)src{
    if(_src != src && ! [_src isEqualToString:src]){
        [src retain];
        [_src release];
        _src = src;
        self.loaded = NO;
        [super setImage:_defaultImage];
    }
}


-(void) updateContentsRect{
    
    CGFloat imageWidth = CGImageGetWidth((CGImageRef)self.layer.contents);
    CGFloat imageHeight = CGImageGetWidth((CGImageRef)self.layer.contents);
    
    
    if(_imageMode && imageWidth >0 && imageHeight >0){
        
        CGSize size = self.bounds.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        CGFloat top = 0,left = 0,right = 0,bottom=0;
        
        if([_imageMode isEqualToString:@"center"]){
            
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    top = bottom = (imageHeight - h) / 2.0;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    left = right = (imageWidth - w) / 2.0 ;
                }
            }
        }
        else if([_imageMode isEqualToString:@"top"]){
            
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    bottom = imageHeight - h;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    left = right = (imageWidth - w) / 2.0 ;
                }
            }
        }
        else if([_imageMode isEqualToString:@"bottom"]){
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    top = imageHeight - h;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    left = right = (imageWidth - w) / 2.0 ;
                }
            }
        }
        else if([_imageMode isEqualToString:@"left"]){
            
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    top = bottom = (imageHeight - h) / 2.0;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    right = imageWidth - w ;
                }
            }
            
        }
        else if([_imageMode isEqualToString:@"right"]){
            
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    top = bottom = (imageHeight - h) / 2.0;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    left = imageWidth - w ;
                }
            }
            
        }
        else if([_imageMode isEqualToString:@"leftTop"]){
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    bottom = imageHeight - h;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    right = imageWidth - w ;
                }
            }
            
        }
        else if([_imageMode isEqualToString:@"rightTop"] ){
            
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    bottom = imageHeight - h;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    left = imageWidth - w ;
                }
            }
            
        }
        else if([_imageMode isEqualToString:@"leftBottom"]){
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    top = imageHeight - h;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    right = imageWidth - w ;
                }
            }
            
        }
        else if([_imageMode isEqualToString:@"rightBottom"]){
            
            CGFloat r1 = height / width;
            CGFloat r2 = imageHeight / imageWidth;
            if(r1 != r2){
                CGFloat w = imageWidth;
                CGFloat h = w * r1;
                if(imageHeight >= h){
                    top = imageHeight - h;
                }
                else{
                    h = imageHeight;
                    w = h / r1;
                    left = imageWidth - w ;
                }
            }
            
        }
        
        self.layer.contentsRect = CGRectMake(left / imageWidth
                                             , top / imageHeight
                                             , (imageWidth - left - right) / imageWidth
                                             , (imageHeight - top - bottom) / imageHeight);
        
    }
    else{
        self.layer.contentsRect = CGRectMake(0, 0, 1.0, 1.0);
    }
}

@end
