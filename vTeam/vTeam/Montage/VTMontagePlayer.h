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

@property(nonatomic,retain) IBOutletCollection(VTMontageScenes) NSArray * scenes;
@property(nonatomic,assign,readonly,getter = isPlaying) BOOL playing;
@property(nonatomic,assign) IBOutlet id delegate;

-(void) play;

-(void) stop;

-(void) addPlayingScehes:(VTMontageScenes * )scenes;

-(void) removePlayingScenes:(VTMontageScenes *) scenes;

@end

@protocol VTMontagePlayerDelegate <NSObject>

@optional

-(void) montagePlayer:(VTMontagePlayer *) player didPlayScenes:(VTMontageScenes *) scenes;

-(void) montagePlayer:(VTMontagePlayer *) player didStopScenes:(VTMontageScenes *) scenes;

@end