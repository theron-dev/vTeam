//
//  VTMontagePlayer.h
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTMontageScenes.h>

@interface VTMontagePlayer : NSObject

@property(nonatomic,readonly) VTMontageScenes * playScenes;
@property(nonatomic,assign,readonly,getter = isPlaying) BOOL playing;
@property(nonatomic,assign) IBOutlet id delegate;

-(void) play:(VTMontageScenes *) scehes;

-(void) stop;

@end

@protocol VTMontagePlayerDelegate <NSObject>

@optional

-(void) montagePlayerDidPlay:(VTMontagePlayer *) player;

-(void) montagePlayerDidStop:(VTMontagePlayer *) player;

@end