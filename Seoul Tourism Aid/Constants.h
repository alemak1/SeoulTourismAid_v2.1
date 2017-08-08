//
//  Constants.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define GOOGLE_API_KEY @"AIzaSyDYMTsEqV2iwISMUFxKPwZNqAcu-yw8SSg"
#define CLIENT_ID @"625367767692-j16r3608poe8amocse5j6rb58i2i47aq.apps.googleusercontent.com"
#define REDIRECT_URL @"com.googleusercontent.apps.625367767692-j16r3608poe8amocse5j6rb58i2i47aq"
#define kGTMAppAuthAuthorizerKey @"GTMAppAuthAuthorizerKey"
#define kGoogleTranslationAPIScope @"https://www.googleapis.com/auth/cloud-translation"
#define kGoogleCloudServicesScope @"https://www.googleapis.com/auth/cloud-platform"
#define kGoogleYouTubeScope @"https://www.googleapis.com/auth/youtube"
#define kGoogleAuthorizationEndpoint @"https://accounts.google.com/o/oauth2/v2/auth"
#define kGoogleTokenEndpoint @"https://www.googleapis.com/oauth2/v4/token"
#define kClientID @"625367767692-j16r3608poe8amocse5j6rb58i2i47aq.apps.googleusercontent.com"
#define kRedirectURL @"com.googleusercontent.apps.625367767692-j16r3608poe8amocse5j6rb58i2i47aq:/oauthredirect"
#define GOOGLE_TRANSLATE_BASE_URL_ENDPOINT @"https://translation.googleapis.com/language/translate/v2"
#define GOOGLE_YOUTUBE_BASE_URL_ENDPOINT @"https://www.googleapis.com/youtube/v3/search?"

#define GOOGLE_PLACES_BASE_URL_ENDPOINT @"https://maps.googleapis.com/maps/api/place/details/json?"
#define GOOLE_SPEECH_RECOGNIZTION_BASE_URL_ENDPOINT @"https://speech.googleapis.com/v1/speech:recognize"
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define DID_REQUEST_LOAD_TOURIST_SITE_DETAIL_CONTROLLER @"didRequestLoadTouristSiteDetailController"
#define DID_RECEIVE_USER_AUTHORIZATION_NOTIFICATION @"didReceiveUserAuthorizationNotification"
#define DID_REQUEST_KOREAN_AUDIO_NOTIFICATION @"requestedKoreanAudioNotification"
#define DID_REQUEST_TOURISM_SITE_INFO_NOTIFICATION @"requestedTouristSiteInfoNotification"
#define DID_REQUEST_PRODUCT_INFO_NOTIFICATION @"requestedProductInfoNotification"
#define DID_REQUEST_NAVIGATION_AID_NOTIFICATION @"requestedNavigationHelpNotification"
#define DID_REQUEST_YOUTUBE_VIDEO_NOTIFICATION @"requestedYoutubeVideoNotification"
#define DID_REQUEST_IMAGE_GALLERY_NOTIFICATION @"requestedImageGalleryNotification"
#define DID_REQUEST_APP_INFO_NOTIFICATION @"requestedAppInfoNotification"
#define DID_REQUEST_WEATHER_INFO_NOTIFICATION @"requestedWeatherNotification"
#define DID_ENCOUNTER_QUESTION_OBJECT_NOTIFICATION @"didEncounterQuestionObjectNotification"

#define DID_REQUEST_BACK_TO_MAIN_MENU_NOTIFICATION @"didRequestBackToMainMenuNotification"
#define DID_REQUEST_BUNNY_GAME_NOTIFICATION @"didRequestBunnyGameNotification"
#define DID_REQUEST_MONITORED_REGIONS_NOTIFICATION @"didRequestMonitoredRegionsNotification"

#define DID_REQUEST_GAME_RESTART_NOTIFICATION @"didRequestGameRestartNotification"
#define DID_SCORE_POINT_NOTIFICATION @"didScorePointNotification"


#define DARK_SKY_API @"ee1cc0493ff35cc8dc97394f1fcb0348"
#define FLICKR_COMMERCIAL_API @"38e3f5d1484cdcbebce6a46e830eb4d6"
#define FLICKR_SECRET_CODE @"2572cb568f28239d"
#endif /* Constants_h */
