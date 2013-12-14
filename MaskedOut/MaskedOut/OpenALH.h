
#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#include <AudioToolbox/AudioToolbox.h>

@interface OpenALH : NSObject

+ (void)initOpenAL;
+ (void)cleanUpOpenAL;
+ (void)playSoundNamed:(NSString *)name withIsFirst:(bool)isFirstPlay;
+ (void)pauseSoundNamed:(NSString *)name;
+ (void)stopSoundNamed:(NSString *)name;
+ (void)loadSoundNamed:(NSString *)name withFileName:(NSURL *)fileName withPitch:(float) pitch;
+ (bool)isPlaying;

@end
