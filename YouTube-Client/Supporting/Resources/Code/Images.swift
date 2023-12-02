//
//  Images.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 30.04.2023.
//

import UIKit

extension Resources {
    enum Images {
        static var youTubeLogo: UIImage? {
            UIImage(named: "YouTube-logo")
        }
        
        static var googleLogo: UIImage? {
            UIImage(named: "google-logo")
        }
        
        static var ellipsis: UIImage? {
            UIImage(systemName: "ellipsis")
        }
        
        static var magnifyingglass: UIImage? {
            UIImage(systemName: "magnifyingglass")
        }
        
        static var bell: UIImage? {
            UIImage(systemName: "bell")
        }
        
        static var close: UIImage? {
            UIImage(systemName: "xmark")
        }
        
        //MARK: - TabBar
        
        enum TabBar {
            
            static var add: UIImage? {
                UIImage(named: "plus")
            }
            
            //MARK: Default
            enum Default {
                static var home: UIImage? {
                    UIImage(named: "homepage")
                }
                
                static var shorst: UIImage? {
                    UIImage(named: "shorts")
                }
                
                static var subscriptions: UIImage? {
                    UIImage(named: "subscribtions")
                }
                
                static var library: UIImage? {
                    UIImage(named: "video-library")
                }
            }
            
            //MARK: - Active
            enum Active {
                static var home: UIImage? {
                    UIImage(named: "homepage-active")
                }
                
                static var shorst: UIImage? {
                    UIImage(named: "shorts-active")
                }
                
                static var subscriptions: UIImage? {
                    UIImage(named: "subscribtions-active")
                }
                
                static var library: UIImage? {
                    UIImage(named: "video-library-active")
                }
            }
        }
    }
}
