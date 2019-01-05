//
//  SSPNotifierNames.swift
//  StarterProject
//
//  Created by Matt Stone on 5/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation

class SSPNotifierNames {
    
    // Network operations
    let SSP_CONNECTION_TIMEOUT = "SSP_CONNECTION_TIMEOUT" as String
    let SSP_NETWORK_OFF        = "SSP_NETWORK_OFF" as String
    let SSP_NETWORK_WIFI       = "SSP_NETWORK_WIFI" as String
    let SSP_NETWORK_WAN        = "SSP_NETWORK_WAN" as String
    
    let SSP_STREAMING_STATE_CHANGE  = "SSP_STREAMING_STATE_CHANGE" as String
    
    let SSP_CLEAN_MEMORY_TRANSITION = "SSP_CLEAN_MEMORY_TRANSITION" as String
    
    // Socket
    let SSP_SOCKET_TOKEN_REQUEST = "SSP_SOCKET_TOKEN_REQUEST" as String
    let SSP_SOCKET_LOGGED_IN     = "SSP_SOCKET_LOGGED_IN" as String
    let SSP_SOCKET_LOGGED_OUT    = "SSP_SOCKET_LOGGED_OUT" as String
    let SSP_SOCKET_DISCONNECTED  = "SSP_SOCKET_DISCONNECTED" as String
    
    // User interactions
    let SSP_USER_CREATE_PRIVACY      = "SSP_USER_CREATE_PRIVACY"     as String
    let SSP_TERMS_AND_CONDITIONS_POPUP               = Notification.Name(rawValue: "SSP_TERMS_AND_CONDITIONS_POPUP")
    let SSP_INTRO_DECLINED_TERMS_AND_CONDITIONS      = Notification.Name(rawValue: "SSP_INTRO_DECLINED_TERMS_AND_CONDITIONS")
    let SSP_INTRO_ACCEPTED_TERMS_AND_CONDITIONS      = Notification.Name(rawValue: "SSP_INTRO_ACCEPTED_TERMS_AND_CONDITIONS")
    let SSP_USER_CREATE_RESPONSE     = "SSP_USER_CREATE_RESPONSE"    as String
    let SSP_USER_EMAIL_CONFIRMATION_RESPONSE = "SSP_USER_EMAIL_CONFIRMATION_RESPONSE" as String
    let SSP_LOGIN_ATTEMPT_RESPONSE   = "SSP_LOGIN_ATTEMPT_RESPONSE"  as String
    let SSP_PASSWORD_CHECK_RESPONSE   = "SSP_PASSWORD_CHECK_RESPONSE"as String
    let SSP_PASSWORD_RESET_RESPONSE  = "SSP_PASSWORD_RESET_RESPONSE" as String
    let SSP_LOG_USER_OUT_WITH_ERROR  = "SSP_LOG_USER_OUT_WITH_ERROR" as String
    let SSP_USER_UPDATE              = "SSP_USER_UPDATE"             as String
    let SSP_USER_SHOW                = "SSP_USER_SHOW"               as String
    let SSP_USER_REFRESH             = "SSP_USER_REFRESH"            as String
    let SSP_USER_SEND_DEVICE         = "SSP_USER_SEND_DEVICE"        as String
    let SSP_USER_UPDATE_PROGRESS     = "SSP_USER_UPDATE_PROGRESS"    as String
    let SSP_USER_WANSSP_TO_KNOW_MORE  = "SSP_USER_WANSSP_TO_KNOW_MORE" as String
    
    let SSP_NO_USER_FOUND            = "SSP_NO_USER_FOUND"           as String
    let SSP_USER_VALID               = "SSP_USER_VALID"              as String
    let SSP_PERFORM_SEGUE            = "SSP_PERFORM_SEGUE"           as String
    
    
    // Miscellaneous
    let SSP_ASK_FOR_NOTIFICATIONS                    = Notification.Name(rawValue: "SSP_ASK_FOR_NOTIFICATIONS")
    let SSP_RESIZE_SCENE_FOR_SAFE_AREA               = Notification.Name(rawValue: "RESIZE_SCENE_FOR_SAFE_AREA")
    let SSP_IMAGE_FETCH_SUCCESS                      = Notification.Name(rawValue: "SSP_IMAGE_FETCH_SUCCESS")
    let SSP_ADD_GESTURE_RECOGNIZER                   = Notification.Name(rawValue: "SSP_ADD_GESTURE_RECOGNIZER")
    let SSP_REMOVE_GESTURE_RECOGNIZER                = Notification.Name(rawValue: "SSP_REMOVE_GESTURE_RECOGNIZER")
    
    let SSP_RETURN_TEXT_FIELD                        = "SSP_RETURN_TEXT_FIELD"                        as String
    let SSP_DISMISS_VIEW_CONTROLLER                  = "SSP_DISMISS_VIEW_CONTROLLER"                  as String
    let SSP_SETUP_OBSERVERS                          = Notification.Name(rawValue: "SSP_SETUP_OBSERVERS")
    let SSP_REMOVE_BLACK_LAYER                       = Notification.Name(rawValue: "SSP_REMOVE_BLACK_LAYER")
    let SSP_FIRST_RESPONDER_CHANGE                   = Notification.Name(rawValue: "SSP_FIRST_RESPONDER_CHANGE")
    
    // Login
    let SSP_UPDATE_FROM_USER_STATUS = "SSP_UPDATE_FROM_USER_STATUS" as String
    let SSP_HANDLE_USER_STATUS   = Notification.Name(rawValue: "SSP_HANDLE_USER_STATUS")
    let SSP_LOGIN_STATUS_UPDATE  = Notification.Name(rawValue: "SSP_LOGIN_STATUS_UPDATE")
    let SSP_SHOW_LOGIN_VC        = Notification.Name(rawValue: "SSP_SHOW_LOGIN_VC")
    
    
    // Local Notifications
    let SSP_FIRE_LOCAL_NOTIFICATION      = "SSP_FIRE_LOCAL_NOTIFICATION"    as String
    let SSP_SCHEDULE_ITEM_NOTIFICATION   = "SSP_SCHEDULE_ITEM_NOTIFICATION" as String
    let SSP_MANAGE_ITEM_NOTIFICATION     = "SSP_MANAGE_ITEM_NOTIFICATION"   as String
    let SSP_SHOW_CONFIRMATION_POPUP      = "SSP_SHOW_CONFIRMATION_POPUP"    as String
    
    // Amazon
    let SSP_AMAZON_FILE_UPLOAD_IN_START    = "SSP_AMAZON_FILE_UPLOAD_IN_START"    as String
    let SSP_AMAZON_FILE_UPLOAD_IN_PROGRESS = "SSP_AMAZON_FILE_UPLOAD_IN_PROGRESS" as String
    let SSP_AMAZON_FILE_UPLOAD_COMPLETE    = "SSP_AMAZON_FILE_UPLOAD_COMPLETE"    as String
    let SSP_AMAZON_UPLOAD_PHOTOS           = "SSP_AMAZON_UPLOAD_PHOTOS"           as String
    
    
    // Game Center
    let SSP_GAME_CENTER_MENU       = "SSP_GAME_CENTER_MENU" as String
    let SSP_GAME_PAUSE             = "SSP_GAME_PAUSE"       as String
    let SSP_GAME_UNPAUSE           = "SSP_GAME_UNPAUSE"     as String
    
    //Video View Controller
    let SSP_SHOW_VIDEO               = Notification.Name(rawValue: "SSP_SHOW_VIDEO")
    let SSP_SET_VIDEO_URL            = "SSP_SET_VIDEO_URL"           as String
    let SSP_SET_VIDEO_THUMBNAIL      = "SSP_SET_VIDEO_THUMBNAIL"     as String
    let SSP_VIDEO_VIEW               = "SSP_VIDEO_VIEW"              as String
    let SSP_DID_DISMISS_VIDEO_VC     = Notification.Name(rawValue: "SSP_DID_DISMISS_VIDEO_VC")
    
    
    // Transactions
    let SSP_TRANSACTIONS_GET         = "SSP_TRANSACTIONS_GET"        as String
    let SSP_TRANSACTION_GET          = "SSP_TRANSACTION_GET"         as String
    
    
    // Support Requests
    let SSP_SUPPORT_REQUESSSP_GET       = "SSP_SUPPORT_REQUESSSP_GET"       as String
    let SSP_SUPPORT_REQUESSSP_CREATE    = "SSP_SUPPORT_REQUESSSP_CREATE"    as String
    let SSP_SUPPORT_REQUESSSP_UPDATE    = "SSP_SUPPORT_REQUESSSP_UPDATE"    as String
    let SSP_SUPPORT_REQUESSSP_SHOW      = "SSP_SUPPORT_REQUESSSP_SHOW"      as String
    let SSP_SUPPORT_REQUESSSP_DISMISS   = "SSP_SUPPORT_REQUESSSP_DISMISS"   as String
    
    // Test Notification
    #if DEBUG
    let TEST_NOTIFICATION               = "TEST_NOTIFICATION"               as String
    #endif
    
    // Segues
    let SSP_NEW_VIEW_CONTROLLER                = "SSP_NEW_VIEW_CONTROLLER" as String
    let SSP_SET_FACEBOOK_VIEW_CONTROLLER_TRUE  = "SSP_SET_FACEBOOK_VIEW_CONTROLLER_TRUE"  as String
    let SSP_SET_FACEBOOK_VIEW_CONTROLLER_FALSE = "SSP_SET_FACEBOOK_VIEW_CONTROLLER_FALSE" as String
    
    // OnDemand Content
    let SSP_ON_DEMAND_CONTENT_AVAILABLE       = Notification.Name(rawValue: "SSP_ON_DEMAND_CONTENT_AVAILABLE")
    let SSP_ON_DEMAND_CONTENT_DOWNLOAD_BEGIN  = Notification.Name(rawValue: "SSP_ON_DEMAND_CONTENT_DOWNLOAD_BEGIN")
    let SSP_ON_DEMAND_CONTENT_DOWNLOAD_UPDATE = Notification.Name(rawValue: "SSP_ON_DEMAND_CONTENT_DOWNLOAD_UPDATE")
    let SSP_ON_DEMAND_CONTENT_DOWNLOAD_ERROR  = Notification.Name(rawValue: "SSP_ON_DEMAND_CONTENT_DOWNLOAD_ERROR")
    
    // Email Invite
    let SSP_EMAIL_INVITE = "SSP_EMAIL_INVITE" as String
    
    // Scroll View
    let SSP_ADD_SCROLLVIEW             = "SSP_ADD_SCROLLVIEW"    as String
    let SSP_REMOVE_SCROLLVIEW          = "SSP_REMOVE_SCROLLVIEW" as String
    let SSP_PASS_SCROLLVIEW            = "SSP_PASS_SCROLLVIEW"   as String
}

