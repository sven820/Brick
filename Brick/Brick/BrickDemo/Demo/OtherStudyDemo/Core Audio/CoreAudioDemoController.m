//
//  CoreAudioDemoController.m
//  Brick
//
//  Created by jinxiaofei on 16/9/25.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "CoreAudioDemoController.h"
#import <AVFoundation/AVFoundation.h>

@interface CoreAudioDemoController ()
@property (nonatomic, readwrite) AudioUnit audioUnit;
@end

@implementation CoreAudioDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (AudioStreamBasicDescription)asbdWithSampleRate:(Float64)sampleRate numberOfChannel:(UInt32)number {
    AudioStreamBasicDescription asbd;
    asbd.mBitsPerChannel =      16;//语音每采样点占用位数
    asbd.mChannelsPerFrame =    number;//1单声道，2立体声
    asbd.mSampleRate =          sampleRate;//采样率
    asbd.mFramesPerPacket =     1;//每个数据包多少帧
    asbd.mBytesPerFrame =       asbd.mBitsPerChannel / 8 * asbd.mChannelsPerFrame;//每帧的bytes数
    asbd.mBytesPerPacket =      asbd.mBytesPerFrame * asbd.mFramesPerPacket;//每个数据包的bytes总数，每帧的bytes数＊每个数据包的帧数
    asbd.mFormatID =            kAudioFormatLinearPCM;//PCM采样
    asbd.mFormatFlags =         kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
    return asbd;
}


- (AudioUnit)createAudioUnitInstance {
    OSStatus status;
    
    AudioUnit unit;
    AudioComponentDescription audioComponentDesc;
    AudioComponent audioComp;
    
    audioComponentDesc.componentType = kAudioUnitType_Output;
    audioComponentDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioComponentDesc.componentFlags = 0;
    audioComponentDesc.componentFlagsMask = 0;
#if TARGET_IPHONE_SIMULATOR
    audioComponentDesc.componentSubType = kAudioUnitSubType_RemoteIO;
#elif TARGET_OS_IPHONE
    audioComponentDesc.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
#endif
    audioComp = AudioComponentFindNext(NULL, &audioComponentDesc);
    if (audioComp == NULL) {
        return nil;
    }
    status = AudioComponentInstanceNew(audioComp, &unit);
    if (status != noErr) {
        return nil;
    }
    
    return unit;
}


@end
