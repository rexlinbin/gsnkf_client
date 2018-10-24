-- Filename: LoginScene.lua
-- Author: fang
-- Date: 2013-05-28
-- Purpose: 该文件用于登录模块

require "script/network/Network"
require "script/utils/BaseUI"
require "script/utils/LuaUtil"
require "script/ui/login/CheckVerionLogic"
require "script/localized/LocalizedUtil"
require "script/utils/SupportUtil"
require "script/ui/login/LoginUtil"
require "db/DB_Heroes"
require "script/GlobalVars"
-- 登录模块
module("LoginScene", package.seeall)

local _username

local _bReconnStatus = false

local _cmiEnterGame


-- 进入游戏的index
_nIndexOfEnterGame = 10001
-- 重新连接的index
_nIndexOfReconn = 10002

local _bLoginStatus
_bLoginInServerStatus = false

_isLoginAgain = false

local function handlerOfEnterGame(...)

    require "script/network/user/UserHandler"
    -- 调用“创建英雄”接口
    UserHandler.createUser()

    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")

end

local function createBgLayer(...)
    local bg_layer = CCLayer:create()

    local bg2 = CCSprite:create("images/login/deslogin.png")
    bg2:setPosition(ccps(0.5, 0.5))
    bg2:setAnchorPoint(ccp(0.5, 0.5))
    bg_layer:addChild(bg2, 1)
    bg2:setScale(g_fScaleY)

    local bg = CCSprite:create("images/login/bg.jpg")
    bg:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2))
    bg:setAnchorPoint(ccp(0.5, 0.5))
    bg_layer:addChild(bg)
    bg:setScale(g_fBgScaleRatio)

    local logoSprite = CCSprite:create("images/login/logo.png")
    logoSprite:setAnchorPoint(ccp(0.5, 0.5))
    logoSprite:setPosition(ccp(bg_layer:getContentSize().width / 2, bg_layer:getContentSize().height * 0.8))
    logoSprite:setScale(g_fElementScaleRatio)
    bg_layer:addChild(logoSprite, 6)

    local effectSprite = XMLSprite:create("images/login/denglujiemian_zhulin_luoye/denglujiemian_zhulin_luoye")
    effectSprite:setScale(g_fElementScaleRatio)
    effectSprite:setPosition(ccp(bg_layer:getContentSize().width * 0.5, bg_layer:getContentSize().height * 0.5))
    effectSprite:setAnchorPoint(ccp(0.5, 0.5))
    bg_layer:addChild(effectSprite, 5)

    local effectSprite2 = XMLSprite:create("images/login/denglujiemian_zhulin/denglujiemian_zhulin")
    -- effectSprite2:setScale(g_fElementScaleRatio)
    effectSprite2:setPosition(ccp(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5))
    effectSprite2:setAnchorPoint(ccp(0.5, 0.5))
    bg:addChild(effectSprite2, 5)

    local effectSprite3 = XMLSprite:create("images/login/denglujiemian_3nian_tubiao/denglujiemian_3nian_tubiao")
    effectSprite3:setScale(g_fElementScaleRatio)
    effectSprite3:setPosition(ccp(bg_layer:getContentSize().width * 0.5, bg_layer:getContentSize().height * 0.8))
    effectSprite3:setAnchorPoint(ccp(0.5, 0.5))
    bg_layer:addChild(effectSprite3, 7)

    return bg_layer
end

local function init(...)
    _bLoginStatus = false
end


-- 进入模块
function enter(...)
    init()

    local scene = CCDirector:sharedDirector():getRunningScene()
    if scene then
        scene:removeAllChildrenWithCleanup(true)    -- 删除当前场景的所有子节点
        CCTextureCache:sharedTextureCache():removeUnusedTextures()    -- 清除所有不用的纹理资源
    else
        scene = CCScene:create()
        CCDirector:sharedDirector():runWithScene(scene)
    end

    BTEventDispatcher:getInstance():removeAll() -- 重置事件派发队列

    BTUtil:setGuideState(false)
    require "script/guide/NewGuide"
    NewGuide.guideClass = ksGuideClose

    local login_layer = CCLayer:create()

    local menu = CCMenu:create()
    menu:setPosition(0, 0)
    login_layer:addChild(menu)

    -- 进入游戏按钮
    _cmiEnterGame = CCMenuItemImage:create("images/login/enter_n.png", "images/login/enter_h.png")
    _cmiEnterGame:setScale(g_fElementScaleRatio)
    _cmiEnterGame:setPosition(ccps(0.5, 0.1))
    _cmiEnterGame:setAnchorPoint(ccp(0.5, 0.5))
    _cmiEnterGame:registerScriptTapHandler(handlerOfEnterGame)
    menu:addChild(_cmiEnterGame)
    local bg = createBgLayer()

    scene:addChild(bg)
    scene:addChild(login_layer)

    --增加背景音乐
    require "script/audio/AudioUtil"
    AudioUtil.playBgm("audio/main.mp3")
end

function setUserInfo(userInfo)
    require "script/model/hero/HeroModel"
    local allHeros = {}
    local hero = {}
    hero['htid'] = userInfo['htid']
    hero['level'] = 1
    allHeros[0] = hero
    HeroModel.setAllHeroes(allHeros)
    enterGame()
end

local _bNotOvertureStatus = false
function enterGame(...)
    -- added by zhz
    require "script/model/user/UserModel"
    require "script/ui/upgrade_tip/UpgradeLayer"
    UserModel.addObserverForLevelUp("UpgradeLayer", UpgradeLayer.createLayer)

    local runningScene = CCDirector:sharedDirector():getRunningScene()

    require "script/model/user/UserModel"
    if (UserHandler.isNewUser == true and not _bNotOvertureStatus) then

        --	if UserHandler.isNewUser then
        function enterBattle(...)
            --通知Platfrorm层用户 跳过剧情,进入首个副本
            Platform.sendInformationToPlatform(Platform.kOutOfStoryLine)

            runningScene:removeAllChildrenWithCleanup(true)
            local battleCallback = function(...)

                require "script/ui/main/MainScene"
                print(GetLocalizeStringBy("key_2747"))

                MainScene.enter()
            end
            require "script/battle/BattleLayer"
            BattleLayer.enterBattle(1, 1001, 0, battleCallback, 1)
        end
        runningScene:removeAllChildrenWithCleanup(true)

        require "script/ui/create_user/SelectUserLayer"
        local sexNumber = SelectUserLayer.getUserSex()
        local sexBool = true
        if (tonumber(sexNumber) == 1) then
            sexBool = false
        elseif (sexNumber == 2) then
            sexBool = true
        end
        print("enter overture layer")
        require "script/guide/overture/BattleLayerLee"
        BattleLayerLee.enterBattle(nil, 1, 0, function(...)
            enterBattle()
        end, 1)
        _bNotOvertureStatus = true
    else
        require "script/guide/NewGuide"
        NewGuide.getOneCopyStatus()
    end
end















