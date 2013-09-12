//
//  VTMontagePlayer.m
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTMontagePlayer.h"

#import <QuartzCore/QuartzCore.h>

@interface VTMontagePlayer(){
    NSTimeInterval _playTimeInterval;
}

@property(nonatomic,retain) CADisplayLink * displayLink;

@end

@implementation VTMontagePlayer

@synthesize playScenes = _playScenes;
@synthesize displayLink = _displayLink;
@synthesize delegate = _delegate;

-(void) dealloc{
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink release];
    [_playScenes release];
    [super dealloc];
}

-(BOOL) isPlaying{
    return _displayLink != nil;
}

-(void) play:(VTMontageScenes *) scehes{
    if(_displayLink == nil){
        
        [scehes retain];
        [_playScenes release];
        _playScenes = scehes;
        
        if(scehes){
            _playTimeInterval = CACurrentMediaTime();
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([_delegate respondsToSelector:@selector(montagePlayerDidPlay:)]){
                    [_delegate montagePlayerDidPlay:self];
                }
                
            });
            

        }
    
    }
}

-(void) tick{
    NSTimeInterval duration = CACurrentMediaTime() - _playTimeInterval;
    if(duration > [_playScenes duration]){
        [_playScenes setValue:1.0];
        [self stop];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([_delegate respondsToSelector:@selector(montagePlayerDidStop:)]){
                [_delegate montagePlayerDidStop:self];
            }
            
        });
    }
    else{
        [_playScenes setCurrent:duration];
    }
}

-(void) stop{
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink release];
    _displayLink = nil;
}

@end
