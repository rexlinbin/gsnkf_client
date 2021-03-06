-- Filename: LordWarRewardLayer.lua
-- Author: DJN
-- Date: 2014-07-31
-- Purpose: 跨服赛奖励预览

module("LordWarRewardLayer", package.seeall)
require "script/audio/AudioUtil"
require "script/ui/lordWar/reward/LordWarRewardTableView"


local _touchPriority    --触摸优先级
local _ZOrder           --Z轴
local _bgLayer          --触摸屏蔽层
local _curMenuItem      --傲视群雄、初出茅庐、关闭 的索引
local _curMenuTag       --按钮索引的tag
local _AoShiTag  = 101  --傲视群雄的tag
local _ChuChuTag = 102  --初出茅庐的tag
local _preViewLayer     --TableView
local _serverTag        --记录当前是服内还是跨服的tag 1:服内 2:跨服

----------------------------------------初始化函数----------------------------------------
local function init()
    _touchPriority = nil
    _ZOrder = nil
    _bgLayer = nil
    _curMenuTag = 101
    _curMenuItem = nil
    _preViewLayer = nil
    _serverTag = nil 
end

----------------------------------------触摸事件函数----------------------------------------
local function onTouchesHandler(eventType,x,y)
    if (eventType == "began") then
        return true
    elseif (eventType == "moved") then
        print("moved")
    else
        print("end")
    end
end

local function onNodeEvent(event)
    if event == "enter" then
        _bgLayer:registerScriptTouchHandler(onTouchesHandler, false, _touchPriority, true)
        _bgLayer:setTouchEnabled(true)
    elseif event == "exit" then
        _bgLayer:unregisterScriptTouchHandler()
    end
end


----------------------------------------UI函数----------------------------------------
--[[
    @des    :创建背景UI
    @param  :
    @return :
--]]
function createBgUI()
    require "script/ui/main/MainScene"
    local bgSize = CCSizeMake(620,840)
    local bgScale = MainScene.elementScale

    --主背景图
    local bgSprite = CCScale9Sprite:create("images/common/viewbg1.png")
    bgSprite:setContentSize(CCSizeMake(bgSize.width,bgSize.height))
    bgSprite:setAnchorPoint(ccp(0.5,0.5))
    bgSprite:setPosition(ccp(_bgLayer:getContentSize().width/2,_bgLayer:getContentSize().height/2))
    bgSprite:setScale(bgScale)
    _bgLayer:addChild(bgSprite)

    --标题背景
    local titleSprite = CCSprite:create("images/common/viewtitle1.png")
    titleSprite:setAnchorPoint(ccp(0.5,0.5))
    titleSprite:setPosition(ccp(bgSprite:getContentSize().width/2,bgSprite:getContentSize().height - 6))
    bgSprite:addChild(titleSprite)
    
    local titleLabel
    --标题
    if(_serverTag == 1)then
        titleLabel = CCLabelTTF:create(GetLocalizeStringBy("djn_9"), g_sFontPangWa, 30)
    elseif (_serverTag == 2)then
        titleLabel = CCLabelTTF:create(GetLocalizeStringBy("djn_10"), g_sFontPangWa, 30)
    else
    end
    titleLabel:setColor(ccc3(0xff,0xe4,0x00))
    titleLabel:setAnchorPoint(ccp(0.5,0.5))
    titleLabel:setPosition(ccp(titleSprite:getContentSize().width/2,titleSprite:getContentSize().height/2))
    titleSprite:addChild(titleLabel)
    --本届用来测试*****那句话
    -- local noteStr = CCLabelTTF:create(GetLocalizeStringBy("djn_38"), g_sFontPangWa, 25)
    -- noteStr:setColor(ccc3(0x78,0x25,0x00))
    -- noteStr:setAnchorPoint(ccp(0.5,1))
    -- noteStr:setPosition(ccp(bgSprite:getContentSize().width/2,bgSprite:getContentSize().height - 36))
    -- bgSprite:addChild(noteStr)

    --二级背景
    local brownSprite = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png")
    brownSprite:setContentSize(CCSizeMake(575,665))
    brownSprite:setAnchorPoint(ccp(0.5,0.5))
    brownSprite:setPosition(ccp(bgSprite:getContentSize().width/2,bgSprite:getContentSize().height/2-15))
    bgSprite:addChild(brownSprite)

    --背景按钮层
    local bgMenu = CCMenu:create()
    bgMenu:setPosition(ccp(0,0))
    bgMenu:setTouchPriority(_touchPriority-1)
    bgSprite:addChild(bgMenu)
    
    --傲视群雄按钮
    --local fullRect = CCRectMake(0,0,73,53)
    local insertRect = CCRectMake(35,20,1,1)
    local btnMenuN_Aoshi = CCScale9Sprite:create(insertRect,"images/common/btn/tab_button/btn1_n.png")
    btnMenuN_Aoshi:setPreferredSize(CCSizeMake(211,43))
    local btnMenuH_Aoshi = CCScale9Sprite:create(insertRect,"images/common/btn/tab_button/btn1_h.png")
    btnMenuH_Aoshi:setPreferredSize(CCSizeMake(211,53))
   
    local AoShiMenuItem = CCMenuItemSprite:create(btnMenuN_Aoshi, nil,btnMenuH_Aoshi)
    AoShiMenuItem:setPosition(ccp(bgSprite:getContentSize().width*0.45,brownSprite:getContentSize().height*0.5+brownSprite:getPositionY()))
    AoShiMenuItem:setAnchorPoint(ccp(1,0))
    AoShiMenuItem:registerScriptTapHandler(menuCallBack)
    bgMenu:addChild(AoShiMenuItem,1,_AoShiTag)
    AoShiMenuItem:setEnabled(false)
    --设置傲视群雄为默认选中的button
    _curMenuItem = AoShiMenuItem
    _curMenuTag = _AoShiTag


    --"傲视群雄"的字 根据是否被点击的状态创建两种字
    local labelAoshi_N = CCLabelTTF:create(GetLocalizeStringBy("djn_12"), g_sFontPangWa, 25)
    labelAoshi_N:setColor(ccc3(0xf4,0xdf,0xcb))
    labelAoshi_N:setAnchorPoint(ccp(0.5,0.5))
    labelAoshi_N:setPosition(ccp(btnMenuN_Aoshi:getContentSize().width*0.5,btnMenuN_Aoshi:getContentSize().height*0.5))
    btnMenuN_Aoshi:addChild(labelAoshi_N)

    local labelAoshi_H = CCRenderLabel:create(GetLocalizeStringBy("djn_12"),g_sFontPangWa , 28, 1 ,ccc3(0x00,0x00,0x00), type_stroke)
    labelAoshi_H:setColor(ccc3(0xff,0xff,0xff))
    labelAoshi_H:setAnchorPoint(ccp(0.5,0.5))
    labelAoshi_H:setPosition(ccp(btnMenuH_Aoshi:getContentSize().width*0.5,btnMenuH_Aoshi:getContentSize().height*0.5-2))
    btnMenuH_Aoshi:addChild(labelAoshi_H)

   
    --初出茅庐按钮 
    local btnMenuN_Chuchu = CCScale9Sprite:create(insertRect,"images/common/btn/tab_button/btn1_n.png")
    btnMenuN_Chuchu:setPreferredSize(CCSizeMake(211,43))
    local btnMenuH_Chuchu = CCScale9Sprite:create(insertRect,"images/common/btn/tab_button/btn1_h.png")
    btnMenuH_Chuchu:setPreferredSize(CCSizeMake(211,53))
    local ChuChuMenuItem = CCMenuItemSprite:create(btnMenuN_Chuchu, nil,btnMenuH_Chuchu)
    ChuChuMenuItem:setPosition(ccp(AoShiMenuItem:getPositionX()+33 ,brownSprite:getContentSize().height*0.5+brownSprite:getPositionY()))
    ChuChuMenuItem:setAnchorPoint(ccp(0,0))
    
    ChuChuMenuItem:registerScriptTapHandler(menuCallBack)
    bgMenu:addChild(ChuChuMenuItem,1,_ChuChuTag)

    --"初出茅庐"的字 根据是否被点击的状态创建两种字
    local labelChuchu_N = CCLabelTTF:create(GetLocalizeStringBy("djn_13"), g_sFontPangWa, 25)
    labelChuchu_N:setColor(ccc3(0xf4,0xdf,0xcb))
    labelChuchu_N:setAnchorPoint(ccp(0.5,0.5))
    labelChuchu_N:setPosition(ccp(btnMenuN_Chuchu:getContentSize().width*0.5,btnMenuN_Chuchu:getContentSize().height*0.5))
    btnMenuN_Chuchu:addChild(labelChuchu_N)

    local labelChuchu_H = CCRenderLabel:create(GetLocalizeStringBy("djn_13"),g_sFontPangWa , 28, 1 ,ccc3(0x00,0x00,0x00), type_stroke)
    labelChuchu_H:setColor(ccc3(0xff,0xff,0xff))
    labelChuchu_H:setAnchorPoint(ccp(0.5,0.5))
    labelChuchu_H:setPosition(ccp(btnMenuH_Chuchu:getContentSize().width*0.5,btnMenuH_Chuchu:getContentSize().height*0.5-2))
    btnMenuH_Chuchu:addChild(labelChuchu_H)

    --关闭按钮
    local closeMenuItem = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png","images/common/btn_close_h.png")
    closeMenuItem:setPosition(ccp(bgSprite:getContentSize().width*1.03,bgSprite:getContentSize().height*1.03))
    closeMenuItem:setAnchorPoint(ccp(1,1))
    closeMenuItem:registerScriptTapHandler(closeCallBack)
    bgMenu:addChild(closeMenuItem)

    --默认进入时展示傲视群雄的奖励
    --（1，1）跨服傲视群雄 （1，2）跨服初出茅庐 (2，1）服内傲视群雄 （2，2）服内初出茅庐 
    _preViewLayer = LordWarRewardTableView.createTableView(_serverTag,1)
    _preViewLayer:setAnchorPoint(ccp(0,0))
    _preViewLayer:setPosition(ccp(0,2))
    _preViewLayer:setTouchPriority(_touchPriority-1)
    brownSprite:addChild(_preViewLayer)
    

   
   
end
----------------------------------------回调函数----------------------------------------
--[[
    @des    :关闭回调
    @param  :
    @return :
--]]
function closeCallBack()
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    _bgLayer:removeFromParentAndCleanup(true)
    _bgLayer = nil
end
----------------------------------------回调函数----------------------------------------
--[[
    @des    :Menu回调
    @param  :
    @return :
--]]

function menuCallBack(tag, item )
    AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
    require "script/ui/tip/AnimationTip"
    _curMenuItem:setEnabled(true)
   -- _curMenuItem:unselected()
    item:setEnabled(false)
    _curMenuItem= item

    if(_curMenuTag == tag) then
        return
    else
        _curMenuTag = tag
    end

    if(tag == _AoShiTag) then
        LordWarRewardTableView.setStage(1)
        LordWarRewardTableView.setCellNum()
        _preViewLayer:reloadData()
  
    elseif(tag == _ChuChuTag) then
        LordWarRewardTableView.setStage(2)
        LordWarRewardTableView.setCellNum()
        _preViewLayer:reloadData()
   end
end

----------------------------------------入口函数----------------------------------------
function showLayer(server,p_touchPriority,p_ZOrder)
    init()
    _touchPriority = p_touchPriority or -550
    _ZOrder = p_ZOrder or 999
    _serverTag = server
    --绿色触摸屏蔽层
    _bgLayer = CCLayerColor:create(ccc4(0x00,0x2e,0x49,153))
    _bgLayer:registerScriptHandler(onNodeEvent)
    local curScene = CCDirector:sharedDirector():getRunningScene()
    curScene:addChild(_bgLayer,_ZOrder) 
    --创建背景UI
    createBgUI()

   
end
--[[
    @des    :获得触摸优先级
    @param  :
    @return :触摸优先级
--]]
function getTouchPriority()
    return _touchPriority
end