//
//  DJIAppActivationSystemTypes.h
//  DJISDK
//
//  Copyright © 2017 DJI. All rights reserved.
//

#ifndef DJIAppActivationSystemTypes_h
#define DJIAppActivationSystemTypes_h


/**
 *  The aircraft's binding state.
 */
typedef NS_ENUM (NSUInteger, DJIAppActivationAircraftBindingState) {


    /**
     *  The binding state of the aircraft is still being determined.
     */
    DJIAppActivationAircraftBindingStateInitial,

    /**
     *  The aircraft is not currently bound. In this state, the aircraft will have 30m
     *  max flight  height and 50m max flight distance limitation. User should finish
     *  the one-off binding  process with DJI GO to unstricted the flight limitation.
     */
    DJIAppActivationAircraftBindingStateUnbound,
    

    /**
     *  The aircraft is flying inside China and it is unbound. Also the network is not
     *  reachable so  the aircraft cannot synchronize the state from the server. In this
     *  state, the aircraft will  have 30m max flight height and 50m max flight distance
     *  limitation. User should connect the  mobile device to the Internet to refresh
     *  the state.
     */
    DJIAppActivationAircraftBindingStateUnboundButCannotSync,

    /**
     *  The aircraft is bound.
     */
    DJIAppActivationAircraftBindingStateBound,

    /**
     *  The aircraft is not bound but it is not currently located in China. Therefore,
     *  binding the aircraft is not required.
     */
    DJIAppActivationAircraftBindingStateNotRequired,

    /**
     *  The aircraft's firmware does not support the App Activation system.
     */
    DJIAppActivationAircraftBindingStateNotSupported,

    /**
     *  Either the aircraft is disconnected or the connected product is not a DJI
     *  aircraft.
     */
    DJIAppActivationAircraftBindingStateUnknown = 0xFF,
};


/**
 *  The App Activation state.
 */
typedef NS_ENUM(NSInteger, DJIAppActivationState) {

    /**
     *  The aircraft's firmware does not support the App Activation System.
     */
    DJIAppActivationStateNotSupported,

    /**
     *  The application needs to be activated by the user through their DJI account.
     *  Use `DJIUserAccountManager` to enable the user to log in. Log in is only
     *  required if the  aircraft is located in China.
     */
    DJIAppActivationStateLoginRequired,

    /**
     *  The application is activated and flight restrictions turned off.
     */
    DJIAppActivationStateActivated,

    /**
     *  Either the aircraft is disconnected or the connected product is not a DJI
     *  aircraft.
     */
    DJIAppActivationStateUnknown = 0xFF,
};


#endif /* DJIAppActivationSystemTypes_h */
