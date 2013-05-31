//
//  VTImageView.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTImageView.h"

@implementation VTImageView

@synthesize src = _src;
@synthesize source = _source;
@synthesize httpTask = _httpTask;
@synthesize defaultImage = _defaultImage;
@synthesize loaded = _loaded;
@synthesize defaultSrc = _defaultSrc;

-(void) dealloc{
    [_src release];
    [_httpTask release];
    [_defaultImage release];
    [_defaultSrc release];
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
    if(_src != src){
        [src retain];
        [_src release];
        _src = src;
        self.loaded = NO;
        [super setImage:_defaultImage];
    }
}

@end
