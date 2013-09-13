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

}

@property(nonatomic,retain) CADisplayLink * displayLink;
@property(nonatomic,readonly) NSMutableArray * playingScenes;
@end

@implementation VTMontagePlayer

@synthesize displayLink = _displayLink;
@synthesize delegate = _delegate;
@synthesize scenes = _scenes;
@synthesize playingScenes = _playingScenes;

-(void) dealloc{
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink release];
    [_scenes release];
    [_playingScenes release];
    [super dealloc];
}

-(BOOL) isPlaying{
    return _displayLink != nil;
}

-(NSMutableArray *) playingScenes{
    if(_playingScenes == nil){
        _playingScenes = [[NSMutableArray alloc] init];
    }
    return _playingScenes;
}

-(void) play{
    
    if(_displayLink == nil){
        
        if([_scenes count]){
            
            [[self playingScenes] addObjectsFromArray:_scenes];
            
            for(VTMontageScenes * scene in _playingScenes){
                [scene setStartTimeInterval:CACurrentMediaTime()];
            }

            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                

                if([_delegate respondsToSelector:@selector(montagePlayerDidPlay:)]){
                    
                    for (VTMontageScenes * scene in _playingScenes) {
                        
                        [_delegate montagePlayer:self didPlayScenes:scene];
                    }
                }
                
            });
        }
    
    }
}

-(void) tick{
    
    
    
    NSInteger c = [_playingScenes count];
    
    for(int i=0;i<c;i++){
        
        VTMontageScenes * scene = [_playingScenes objectAtIndex:i];
        
        NSTimeInterval duration = CACurrentMediaTime() - scene.startTimeInterval;
        
        if(scene.repeatCount == 0){
            if(duration > [scene duration]){
                
                [scene setValue:1.0];
                
                if([_delegate respondsToSelector:@selector(montagePlayer:didStopScenes:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_delegate montagePlayer:self didStopScenes:scene];
                    });
                }
                
                [_playingScenes removeObjectAtIndex:i];
                i --;
                c --;
            }
            else{
                [scene setCurrent:duration];
            }
        }
        else if(duration <= ([scene isRepeatAutoreverses] ? 2 :1) * scene.repeatCount * scene.duration){
            
            NSInteger playCount = (NSInteger) (duration / scene.duration);
            NSTimeInterval current = duration - (scene.duration * playCount);
            
            if([scene isRepeatAutoreverses]){
            
                if((playCount % 2)){
                    [scene setCurrent:scene.duration - current];
                }
                else{
                    [scene setCurrent:current];
                }
                
            }
            else{
                [scene setCurrent:current];
            }
            
        }
        else{
            
            if([_delegate respondsToSelector:@selector(montagePlayer:didStopScenes:)]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate montagePlayer:self didStopScenes:scene];
                });
            }
            
            [_playingScenes removeObjectAtIndex:i];
            i --;
            c --;
        }
    }

}

-(void) stop{
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink release];
    _displayLink = nil;
    [_playingScenes removeAllObjects];
}

-(void) addPlayingScehes:(VTMontageScenes * )scenes{
    [[self playingScenes] addObject:scenes];
    if([self isPlaying]){
        [scenes setStartTimeInterval:CACurrentMediaTime()];
    }
}

-(void) removePlayingScenes:(VTMontageScenes *) scenes{
    [_playingScenes removeObject:scenes];
}

@end
