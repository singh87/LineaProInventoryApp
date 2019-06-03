//
//  IQCustomDevice.h
//  IPCIQ
//
//  Copyright © 2016 Infinite Peripherals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IQCustomDevice : NSObject

///
@property (readonly, nonatomic) NSString *deviceName;

///
@property (readonly, nonatomic) NSString *deviceModel;

///
@property (readonly, nonatomic) NSString *deviceSerial;

///
@property (readonly, nonatomic) NSString *pluginVersion;

/**
 Create a new custom device object.
 @param deviceName A name for you device
 @param deviceModel Device model
 @param deviceSerial Device serial
 @param level A block that return battery level in int
 @return IQCustomDevice
 */
- (instancetype)initWithDeviceName:(NSString *)deviceName model:(NSString *)deviceModel serial:(NSString *)deviceSerial battery:(int (^)(void))level;

/**
 Set custom key-value for this device
 @param block A block that return a value
 @param field Key name
 @param prettyName The display name on portal
 */
- (void)setDeviceValueWithBlock:(NSString *(^)(void))block forField:(NSString *)field title:(NSString *)prettyName;

/**
 The info of the custom device
 @return NSDictionary
 */
- (NSDictionary *)getCustomDeviceDetails;

/**
 The plugin info for this module
 @return NSDictionary
 */
- (NSDictionary *)getCustomDevicePluginData;

/**
 This image will be uploaded to portal and shown on the list of devices
 @param image The full-size image
 @param thumbnail The scaled down version
 */
- (void)setDeviceImage:(UIImage *)image andThumbnail:(UIImage *)thumbnail;

/**
 Set extension plugin version number
 @param major Version major
 @param minor Version minor
 @param build Version build
 */
- (void)setPluginVersionMajor:(NSInteger)major minor:(NSInteger)minor build:(NSInteger)build;

/**
 UNAVAILABLE
 */
- (id)init NS_UNAVAILABLE;
+ (id)new NS_UNAVAILABLE;

@end
