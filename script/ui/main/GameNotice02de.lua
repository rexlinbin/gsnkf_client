-- Filename: GameNotice02.lua.
-- Author: fang.
-- Date: 2013-12-06
-- Purpose: 该文件用于实现进入主场景前的游戏公告

module("GameNotice02", package.seeall)

-- "|0xff,0xff,0xff|活动公告内容0000000000001111======|0x00,0xFF,0x18|活动公告内容0000000000002222"
--[[
local _noticeText = 	"|0x00,0x0F,0x18|公告标题|0x4a,0x15,0x03|        活动公告内容000000000000fdafdsafdasfasd公告内容fsafasdfsdafsd公告内容afasfddas公告内容fsa1111======"..
					"|0x00,0x0F,0x18|公告标题|0x4a,0x15,0x03|        活动公公告内容告内容活动公公告内容告内容活动公公告内容告内容活动公公告内容告内容\n活动公公告内容告内容活动公公告内容告内容活动公公告内容告内容\n活动公公告内容告内容活动公公告内容告内容活动公公告内容告内容\n0公告内容0公告内容0公告内容00000公告内容000公告内容02222======"..
					"|0x00,0xFF,0x18|公告标题|0xf0,0xFF,0x18|活动公告内容000\n0000000003333======"..
					"|0x0f,0x0F,0x18|公告标题|0x0f,0xFF,0x18|活动公告内容0000000000004444======"..
					"|0xff,0xF0,0x18|公告标题|0xff,0x00,0x18|活动公告内容0000000000005555======"..
					"|0xf0,0xFF,0x18|公告标题|0xf0,0x0F,0x00|活动公告内容0000000000006666"
--]]
local _noticeText = nil
local _tagOfNotice02Layer=200123

-- 拉公告的服务器关键字
local _serverKey

--local _noticeText 

local _webNoticeView = nil

local layer = nil

local NOTICE_URL = ""



local isFirst = true

-- 进入游戏按钮事件处理
function fnHandlerOfEnterGame(tag, obj)
    if(tag~=nil)then
        require "script/audio/AudioUtil"
        AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    end

    if(_webNoticeView)then
        _webNoticeView:removeWebView()
        -- _webNoticeView:release()
        -- _webNoticeView = nil
    end

    -- 移除公告面板
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    local noticeLayer = runningScene:getChildByTag(_tagOfNotice02Layer)
    if noticeLayer ~= nil then
        noticeLayer:removeFromParentAndCleanup(true)
    end

    if( isFirst == true and MainScene.getWebActivityUrl() ~= nil)then
        -- web运营活动
        require "script/ui/menu/WebNoticeLayer"
        WebNoticeLayer.show()
        isFirst = false
    end
   -- _noticeText = nil
end

function deleteWebView( )
    if(_webNoticeView)then
        _webNoticeView:removeWebView()
        -- _webNoticeView:release()
        _webNoticeView = nil
    end
end

-- 游戏公告单元格
function createCell(tParam)
	local tPreferredSize = {width=400, height=200}
    local cs9Bg = CCScale9Sprite:create(CCRectMake(52, 44, 6, 4), "images/game_notice/cell_bg.png")
    local size = cs9Bg:getContentSize()

    local csTitleBg = CCSprite:create("images/game_notice/title_bg.png")
    csTitleBg:setAnchorPoint(ccp(0.5, 1))
    cs9Bg:addChild(csTitleBg)

    local clTitle = CCRenderLabel:create(tParam[3], g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    local colors = string.split(tParam[2], ",")
    clTitle:setColor(ccc3(colors[1], colors[2], colors[3]))
    -- clTitle:setColor(ccc3(0x00, 0xff, 0x18)  --固定标题颜色
    clTitle:setAnchorPoint(ccp(0.5, 0.5))
    clTitle:setPosition(ccp(csTitleBg:getContentSize().width/2, csTitleBg:getContentSize().height/2))
    csTitleBg:addChild(clTitle)

    -- 文本内容区
    -- print("createCell text:",tParam[5])
    local str = "Wrong Platform"

    if g_system_type == kBT_PLATFORM_IOS then
        str = string.gsub(tParam[5], "\n", " \n")
    else
        str = tParam[5]
    end

    print("str  is ", str)
	local clTextContent = CCLabelTTF:create(str, g_sFontName, 21, CCSizeMake(tPreferredSize.width-10, 0), kCCTextAlignmentLeft)
	local colors = string.split(tParam[4], ",")
    clTextContent:setColor(ccc3(colors[1], colors[2], colors[3]))
    clTextContent:setAnchorPoint(ccp(0, 1))
    cs9Bg:addChild(clTextContent)

    local tTitleSize = csTitleBg:getContentSize()
    local tTextContentSize = clTextContent:getContentSize()
    local nBgHeight = tTitleSize.height + 6 + tTextContentSize.height + 6
	if nBgHeight < 151 then
		nBgHeight = 151
	end
    nBgHeight = nBgHeight 
    cs9Bg:setContentSize(CCSizeMake(410, nBgHeight))
    csTitleBg:setPosition(ccp(cs9Bg:getContentSize().width/2, nBgHeight))
    clTextContent:setPosition(ccp(5, nBgHeight-tTitleSize.height))

    return cs9Bg, nBgHeight
end

local function onTouchesHandler( eventType, x, y )

    return true
end

local function fnHandlerOfOnTouchLayer(event, x, y)
    if (event == "enter") then
        layer:registerScriptTouchHandler(onTouchesHandler, false, -5701, true)
        layer:setTouchEnabled(true)
        MainScene.isShowFloatingWindow(false)
    elseif (event == "exit") then
        MainScene.isShowFloatingWindow(true)
    end
    return true
end


function showWebGameNotice( ... )
    
end

function showGameNotice()

    require "script/utils/LuaUtil"
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    if runningScene == nil then
        runningScene = CCScene:create()
        CCDirector:sharedDirector():runWithScene(runningScene)
    end

    layer = CCLayerColor:create(ccc4(0,0,0,100))
    layer:registerScriptHandler(fnHandlerOfOnTouchLayer)
    runningScene:addChild(layer, 10001, _tagOfNotice02Layer)
    

-- 层背景图
    local csBg = CCSprite:create("images/game_notice/background.png")
    layer:addChild(csBg)
    csBg:setScale(g_fElementScaleRatio)
    csBg:setAnchorPoint(ccp(0.5, 0.5))
    csBg:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))

    local x, y = csBg:getPosition()
    local contsize = csBg:getContentSize()
    

    require "script/libs/LuaCC"
    local menu = CCMenu:create()
    menu:setPosition(ccp(0, 0))
    menu:setAnchorPoint(ccp(0, 0))
    menu:setTouchPriority(-9999999999)
    csBg:addChild(menu)

    -- local btnEnterGame= LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png", CCSizeMake(198,73), GetLocalizeStringBy("key_2281"), ccc3(255,222,0))
    btnEnterGame = CCMenuItemImage:create("images/game_notice/enter_button_n.png", "images/game_notice/enter_button_h.png")
    btnEnterGame:registerScriptTapHandler(fnHandlerOfEnterGame)
    btnEnterGame:setPosition(ccp(320, 58))
    btnEnterGame:setAnchorPoint(ccp(0.5, 0.5))
    menu:addChild(btnEnterGame)


    if(ZYWebView ~= nil)then

        local w_x = g_winSize.width/2 - 320*g_fElementScaleRatio + 106*g_fElementScaleRatio
        local w_y = g_winSize.height/2 + 915/2*g_fElementScaleRatio - 186*g_fElementScaleRatio - 410*g_fElementScaleRatio

        print("w_yw_y=", w_y)

        _webNoticeView = ZYWebView:create()
        _webNoticeView:showWebView(getWebNoticeUrl(443*g_fElementScaleRatio) , w_x, w_y, 443*g_fElementScaleRatio, 410*g_fElementScaleRatio)
    else
        local noticelayer = getNoticeScrollView()
        if(noticelayer)then
            csBg:addChild(noticelayer)
        end
    end

    

end


function getNoticeScrollView()
    local tArrContents = {}
    local tArrData = string.split(_noticeText, "======")
    for i=1, #tArrData do 
        local colorAndText = string.split(tArrData[i], "|")
        print_t(colorAndText)
        if(table.count(colorAndText) == 5 )then
            -- 检查格式
            table.insert(tArrContents, colorAndText)
        else
            -- 格式不对就不显示
            return
        end
    end

-- 灰色背景
    local preferredSize = CCSizeMake(443, 410) -- {width=562, height=666}
    local csvContent = CCScrollView:create()
    csvContent:setViewSize(CCSizeMake(preferredSize.width, preferredSize.height))
    csvContent:setDirection(kCCScrollViewDirectionVertical)
    csvContent:setTouchPriority(-5703)
    csvContent:setBounceable(true)
    local clContentContainer = CCLayer:create()
    csvContent:setContainer(clContentContainer)
    csvContent:setPosition(ccp(108, 186))

    local vCellOffset = 2
    local nAccuHeight=0
    local x_pos = preferredSize.width/2
    local y_pos = 0
    local anchorPoint = ccp(0.5, 1)
    for i=1, #tArrContents do
        local cell, nHeight = createCell(tArrContents[#tArrContents-i+1])
        cell:setAnchorPoint(anchorPoint)
        cell:setPosition(ccp(x_pos, y_pos+nHeight))
        clContentContainer:addChild(cell)
        y_pos = y_pos + nHeight + vCellOffset
    end
    clContentContainer:setContentSize(CCSizeMake(preferredSize.width, y_pos))
    clContentContainer:setPosition(ccp(0, 650-y_pos))
    csvContent:setContentOffset(ccp(0,csvContent:getViewSize().height-clContentContainer:getContentSize().height))

    return csvContent
end

function getWebNoticeUrl(b_width)
    if(g_debug_mode == true)then
        NOTICE_URL = "http://172.16.150.129/phone/supernotice?"
    else
        NOTICE_URL = "http://172.16.150.129/phone/notice/index.html?"
    end
    local n_url = NOTICE_URL .. "pl="..Platform.getPlName().."&gn=sanguo&os="..Platform.getOS().."&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey=".._serverKey
    if(b_width ~= nil)then
        n_url = n_url .. "&browser_width=" .. b_width/NSBundleInfo:getScreenScale()
    end
    print("n_url=", n_url)
    return n_url
end

function setServerKey( serverKey )
    _serverKey = serverKey
end

function setNoticeText(pText)
    _noticeText = pText
end

-- http://124.205.151.82/phone/notice?pl=91phone&gn=sanguo&os=ios&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey=4000001
-- 通过服务器标识serverKey拉取第二类通知
function fetchNotice02FromServer(serverKey)
    _serverKey = serverKey
    local plName = Platform.getPlName()
    local OS = Platform.getOS()
    local url
    if g_debug_mode then
        if Platform.getDomain_debug ~= nil then
            url = Platform.getDomain_debug().."phone/notice?pl="..plName.."&gn=sanguo&os="..OS.."&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey="..serverKey
        else
            url = "http://124.205.151.82/phone/notice?pl="..plName.."&gn=sanguo&os="..OS.."&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey="..serverKey
        end
    else
        if Platform.getDomain ~= nil then
            url = Platform.getDomain().."phone/notice?pl="..plName.."&gn=sanguo&os="..OS.."&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey="..serverKey
        else
            url = "http://mapifknsg.zuiyouxi.com/phone/notice?pl="..plName.."&gn=sanguo&os="..OS.."&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey="..serverKey
        end
    end
    print("notice url = ", url)
    local httpClient = CCHttpRequest:open(url, kHttpGet)
    httpClient:sendWithHandler(function(res, hnd)
        if res:getResponseCode() == 200 then
            setNoticeText(res:getResponseData())
        end
    end)
end
