//
//  GIFView.m
//  SinaFramework
//
//  Created by zhang hailong on 12-11-15.
//  Copyright (c) 2012年 hailong.org. All rights reserved.
//

#import "GIFView.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>

@interface GIFView()

@property(nonatomic,assign) NSInteger currentIndex;

-(void) nextAnimating;

-(void) startAnimating;

-(void) stopAnimating;

@end

@implementation GIFView

@synthesize imageSource = _imageSource;
@synthesize gifURL = _gifURL;
@synthesize currentIndex = _currentIndex;

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


-(void) dealloc{
    [_imageSource release];
    [super dealloc];
}

-(void) setGifURL:(NSURL *)gifURL{
    if(_gifURL != gifURL){
        [_gifURL release];
        _gifURL = [gifURL retain];
        
        CGImageSourceRef s = CGImageSourceCreateWithURL((CFURLRef)gifURL, nil);
        
        self.imageSource = (id)s;
        
        CFRelease(s);

    }
}

-(void) setImageSource:(id)imageSource{
    if(_imageSource  != imageSource){
        [_imageSource release];
        _imageSource = [imageSource retain];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextAnimating) object:nil];
        if(self.window){
            [self startAnimating];
        }
    }
}

-(void) _resetImageSource{
    
    if(_imageSource && _currentIndex < CGImageSourceGetCount((CGImageSourceRef)_imageSource)){
        CGImageRef image = CGImageSourceCreateImageAtIndex((CGImageSourceRef)_imageSource, _currentIndex, nil);
        
        self.layer.contents = (id)image;
        
        CGImageRelease(image);
    }
    else{
        self.layer.contents = nil;
    }
}

-(void) nextAnimating{
    if(_imageSource ){
        
        size_t count = CGImageSourceGetCount((CGImageSourceRef)_imageSource);
        
        _currentIndex ++;
        
        if(_currentIndex >= count){
            _currentIndex =0;
        }
        
        [self _resetImageSource];
        
        CFDictionaryRef p = CGImageSourceCopyProperties((CGImageSourceRef)_imageSource, nil);
        
        float delay = [[(id)p valueForKeyPath:@"{GIF}.DelayTime"] floatValue];
        
        if(delay == 0.0){
            delay = 0.15;
        }
        
        [self performSelector:@selector(nextAnimating) withObject:nil afterDelay:delay];
        
        CFRelease(p);
    }
    else{
        [self _resetImageSource];
    }
}

-(void) startAnimating{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextAnimating) object:nil];
    [self nextAnimating];
}

-(void) stopAnimating{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextAnimating) object:nil];
}

-(void) didMoveToWindow{
    [super didMoveToWindow];
    if(self.window){
        [self startAnimating];
    }
    else{
        [self stopAnimating];
    }
}

@end
