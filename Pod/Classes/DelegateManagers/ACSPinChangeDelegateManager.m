//
// Created by Orlando Schäfer on 18/12/14.
// Copyright (c) 2014 arconsis IT-Solutions GmbH. All rights reserved.
//

#import "ACSPinChangeDelegateManager.h"


@implementation ACSPinChangeDelegateManager


#pragma mark - Change Delegates

- (NSString *)pinStringForPinChangeController:(ACSPinChangeController *)pinChangeController
{
    return [self storedPin];
}

- (BOOL)alreadyHasRetriesForPinChangeController:(ACSPinChangeController *)pinChangeController
{
    return [self.keychainHelper retriesToGoCount] < [self.keychainHelper retriesMax];
}

- (NSUInteger)retriesMaxForPinChangeController:(ACSPinChangeController *)pinChangeController
{
    return [self.keychainHelper retriesToGoCount];
}

- (void)pinChangeController:(ACSPinChangeController *)pinChangeController didChangePIN:(NSString *)pin
{
    [self.keychainHelper savePin:pin];
    if ([self.pinControllerDelegate respondsToSelector:@selector(pinChangeController:didChangePin:)]) {
        [self.pinControllerDelegate pinChangeController:pinChangeController didChangePin:pin];
    }

    [pinChangeController dismissViewControllerAnimated:YES completion:nil];
}

- (void)pinChangeControllerDidVerifyOldPIN:(ACSPinChangeController *)pinChangeController
{
    [self.keychainHelper resetRetriesToGoCount];
}

- (void)pinChangeControllerCouldNotVerifyOldPIN:(ACSPinChangeController *)pinChangeController
{
    [self.keychainHelper resetRetriesToGoCount];
    if ([self.pinControllerDelegate respondsToSelector:@selector(pinControllerCouldNotVerifyPin:)]) {
        [self.pinControllerDelegate pinControllerCouldNotVerifyPin:pinChangeController];
    }
    [pinChangeController dismissViewControllerAnimated:YES completion:nil];
}

- (void)pinChangeControllerDidEnterWrongOldPIN:(ACSPinChangeController *)pinChangeController onlyOneRetryLeft:(BOOL)onlyOneRetryLeft
{

    [self.keychainHelper incrementRetryCount];

    if ([self.pinControllerDelegate respondsToSelector:@selector(pinControllerDidEnterWrongPin:lastRetry:)]) {
        [self.pinControllerDelegate pinControllerDidEnterWrongPin:pinChangeController lastRetry:onlyOneRetryLeft];
    }
}

- (void)pinChangeController:(ACSPinChangeController *)pinChangeController didSelectCancelButtonItem:(UIBarButtonItem *)cancelButtonItem
{
    if ([self.pinControllerDelegate respondsToSelector:@selector(pinControllerDidSelectCancel:)]) {
        [self.pinControllerDelegate pinControllerDidSelectCancel:pinChangeController];
    }
}

@end