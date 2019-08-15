//
//  MClassMap.swift
//  Medel
//
//  Created by 张剑飞 on 2017/4/29.
//
//

import MedelUI
import Foundation
import MNavigator
import MedelKit
import UserCenter
import HomePage
import Plaza
import YouWanna
import Search
import Detail
import Topic
import MShare
import Collobook
import Outfit

class MClassMap {
    static var config: [String : MNavigatable.Type] = [
        // Main
        "main" : TabBarController.self,
        
        // AlibcTrade
        "showcarts": AlibcTradeShowMyCarts.self,
        "showorders": AlibcTradeShowMyOrders.self,
        "showitem": AlibcTradeShowItemDetail.self,
        "additem": AlibcTradeShowAddItem.self,
        
        // H5
        "web": MedelKit.WebViewController.self,
        
        // MedelUI
        "facerebuild": MedelUI.FaceRebuild.self,
        "bodyrebuild": MedelUI.MedelRebuild.self,
        "bodyrebuildfirst": MedelUI.MedelRebuildFirst.self,
        "bodycheck": MedelUI.MedelCheck.self,
        
        // UserCenter
        "feedback": UserCenter.FeedBackViewController.self,
        "about": UserCenter.AboutPageViewController.self,
        "setting": UserCenter.SettingViewController.self,
        "settingname": UserCenter.SettingNameViewController.self,
        "settingnotification": UserCenter.SettingNotificationViewController.self,
        "notification": UserCenter.MessageViewController.self,
        "follow": UserCenter.FollowViewController.self,
        "history": UserCenter.HistoryViewController.self,
        
        // HomePage 
        "artist": HomePage.ArtistViewController.self,
        "recommendfollow": HomePage.RecommendFollowViewController.self,
        
        // Plaza
        "storeList" : Plaza.StoreListViewController.self,
        "store": Plaza.StorePageViewController.self,
        "newArrival": Plaza.NewArrivalViewController.self,
        "storeOverview": Plaza.StoreOverviewViewController.self,
        "CategoryPage": Plaza.CategoryPageViewController.self,
        
        //YouWanna
        "wannatest":YouWanna.WannaTestVC.self,
        "wannatestresultvc":YouWanna.WannaTestResultVC.self,
        "wannarecommend":YouWanna.RecommendClothesVC.self,
        "wannasecondlook":YouWanna.SecondLookResultVC.self,
        "wannaselectresult":YouWanna.SelectedResultVC.self,
        "wannacheck": HomePage.YouWannaModule.self,
        
        // Search
        "search": Search.SearchViewController.self,
        "searchresult": Search.SearchResultViewController.self,
        "searchstores": Search.SearchBrandListViewController.self,
        
        //SwitchToWardrobe
        "wardrobe": SwitchToWardrobe.self,
        
        //Detail
        "sku": Detail.DetailPageViewController.self,
        "collocation": Detail.CollocationViewController.self,
        
        //Topic
        "topic": Topic.TopicDispatch.self,
        "skutopic": Topic.SkuTopicViewController.self,
        "expert": Topic.ExpertTopicViewController.self,
        "topiclist": Topic.TopicListViewController.self,
        "comment" : Topic.CommentViewController.self,
        "hometopic": Topic.HomeTopicVC.self,
        "alltopic": Topic.AllTopicListVC.self,
        "topicfiltervc":Topic.TopicFilterVC.self,
        "hotwordmodule":Topic.TopicHotWordModule.self,
        
        // Share
        "sharemedel": MShare.MedelView.self,
        "share": MShare.ShareView.self,
        
        // Collobook
        "collobook": CollobookViewController.self,
        "collobooklist": CollobookListViewController.self,
        "heji": CollobookViewController.self,

        // Outfit
        "showoutfit": Outfit.ShowOutfit.self
    ]
}
