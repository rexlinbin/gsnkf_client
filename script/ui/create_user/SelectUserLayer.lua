-- Filename： SelectUserLayer.lua
-- Author：		zhz
-- Date：		2013-9-2
-- Purpose：		创建角色和名字

module("SelectUserLayer",  package.seeall)

require "script/network/RequestCenter"
require "script/ui/tip/AnimationTip"
-- require "script/ui/create_user/UserCache"

local IMG_PATH = "images/new_user/"
local _selectLayer				-- 创建用户的界面
local _selectBg 				-- 背景
local _utid						--  用户模版id 1:女 2:男 
local _selectSprite				-- 选中的sprite
local _nameEditBox				-- 名字的editBox
local _curName					-- 当前用户的选中的名字
local _curIndex					-- 当前第n个名字
local _UserName				-- 用户的姓名
local _createUserBtn
local function init()
	_selectLayer = nil
	_selectBg = nil
	_utid = 2
	_UserName = {"","冷月灬雪魂","冰雪灬冥月","血月灬魔魂"}
	_selectSprite = nil
	_nameEditBox = nil
	_curIndex = 0
	_createUserBtn = nil

end
-- 通过 utid创建 userSprite
local function createUserSpriteByUtid()

	if(_utid ==1) then  -- 女主
		_selectSprite = CCSprite:create(IMG_PATH .. "girl.png")
		_selectSprite:setPosition(ccps(0.52, 331/960))
		_selectSprite:setAnchorPoint(ccp(0.5,0))
		setAdaptNode(_selectSprite)
		_selectLayer:addChild(_selectSprite)
	elseif(_utid ==2 ) then
		_selectSprite = CCSprite:create(IMG_PATH .. "boy.png")
		_selectSprite:setPosition(ccps(0.408, 331/960))
		_selectSprite:setAnchorPoint(ccp(0.5,0))
		setAdaptNode(_selectSprite)
		_selectLayer:addChild(_selectSprite)
	end

end

-- 返回按钮的回调函数
local function backBtnCb()
	require "script/ui/create_user/UserLayer"
	_selectLayer:removeFromParentAndCleanup(true)
	_selectLayer = nil
	local userLayer = UserLayer.createUserLayer()
	local scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(userLayer)

end

-- 创建EditorBox
local function createNameBox( )
	_nameEditBox = CCEditBox:create(CCSizeMake(342,59), CCScale9Sprite:create(IMG_PATH .."input.png"))
	_nameEditBox:setPosition(ccps(0.5,158/960))
	_nameEditBox:setAnchorPoint(ccp(0.5,0))
	 _nameEditBox:setPlaceHolder(GetLocalizeStringBy("key_2136"))
	_nameEditBox:setMaxLength(10)
	_nameEditBox:setFont(g_sFontName,21)
	setAdaptNode(_nameEditBox)
	_selectLayer:addChild(_nameEditBox)

end


-- 获取随即名字
local function getRandomName( )
	_curName = _UserName[1]
	_curIndex = 1
	_nameEditBox:setText("" .. _curName)
end

-- 得到用户的性别：用户模版id 1:女 2:男 
function getUserSex( )
	return _utid
end



--  汉字的utf8 转换，
local function getStringLength( str)
    local strLen = 0
    local i =1
    while i<= #str do
        if(string.byte(str,i) > 127) then
            -- 汉字
            strLen = strLen + 2
            i= i+ 3
        else
            i =i+1
            strLen = strLen + 1
        end
    end
    return strLen
end

-- 创建角色按钮的回调函数
local function createUserCb( tag,item)
	_curName = _nameEditBox:getText()
	local user = {}
	user["uid"] = 10001
	user["uname"] = _curName
	user["utid"] = _utid
	if(_utid ==1) then  -- 女主
		user["htid"] = 20002
	elseif(_utid ==2 ) then
		user["htid"] = 20001
	end

	user["hid"] = 10010001
	user["level"] = 1
	user["execution"] = 500
	user["execution_time"] = os.time()
	user["execution_max_num"] = 150
	user["buy_execution_time"] = 0
	user["buy_execution_accum"] = 0
	user["vip"] = 0
	user["silver_num"] = 0
	user["gold_num"] = 0
	user["exp_num"] = 0
	user["soul_num"] = 0
	user["wm_num"] = 0
	user["stamina"] = 20
	user["stamina_time"] = os.time()
	user["stamina_max_num"] = 20
	user["buy_stamina_time"] = 0
	user["buy_stamina_accum"] = 0
	user["fight_cdtime"] = 0
	user["ban_chat_time"] = 0
	user["max_level"] = 200
	user["hero_limit"] = 100
	user["charge_gold"] = 0
	user["jewel_num"] = 0
	user["prestige_num"] = 0
	user["figure"] = 0
	user["title"] = 0
	user["fight_force"] = 0
	user["dayOffset"] = 10001
	user["fame_num"] = 0
	user["book_num"] = 0
	user["fs_exp"] = 0

	local formatInfo = {}
	formatInfo['1'] = 10010001

	if(_curName== "") then
		AnimationTip.showTip(GetLocalizeStringBy("key_1706") )
		return
	else
		if (getStringLength(_curName)>10) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2250"))
	 		return
		end
	end
	item:setEnabled(false)
	local cjson = require "cjson"
	local b_userinfo = cjson.encode(user)
	local b_formatinfo = cjson.encode(formatInfo)
	CCUserDefault:sharedUserDefault():setStringForKey("user",b_userinfo)
	CCUserDefault:sharedUserDefault():setStringForKey("format",b_formatinfo)
	CCUserDefault:sharedUserDefault():flush()
	require "script/network/user/UserHandler"
	UserHandler.setUserInfo(user)
end 

-- 置筛子的回调函数
local function sieveBtnCb( )
	_curIndex = _curIndex + 1
	if(_curIndex <= 3 ) then
		_nameEditBox:setText("" .. _UserName[_curIndex])
	else
		getRandomName()
	end
end

function createSelectLayer( utid )
	init()
	_utid = utid
	_selectLayer = CCLayer:create()
	local scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(_selectLayer,101)
	-- 背景
	_selectBg = CCSprite:create(IMG_PATH .. "user_bg.jpg")
	_selectBg:setPosition(ccps(0.5,0.5))
	_selectBg:setAnchorPoint(ccp(0.5,0.5))
	_selectLayer:addChild(_selectBg)
	setAllScreenNode(_selectBg)

	-- 站台
	local userStage = CCSprite:create(IMG_PATH .. "stage.png")
	userStage:setPosition(ccps(0.5,240/960))
	userStage:setAnchorPoint(ccp(0.5,0))
	setAdaptNode(userStage)
	_selectLayer:addChild(userStage)

	createUserSpriteByUtid()

	-- 返回按钮
	local menu = CCMenu:create()
	menu:setPosition(ccp(0,0))
	_selectLayer:addChild(menu)
	local backBtn = CCMenuItemImage:create("images/common/close_btn_n.png", "images/common/close_btn_h.png")
	backBtn:setPosition(ccps(533/640,830/960))
	setAdaptNode(backBtn)
	backBtn:registerScriptTapHandler(backBtnCb)
	menu:addChild(backBtn)

	-- 创建角色按钮
	_createUserBtn = CCMenuItemImage:create(IMG_PATH .. "create/create_usr_n.png", IMG_PATH .. "create/create_usr_h.png")
	_createUserBtn:setPosition(ccps(0.5,42/960))
	_createUserBtn:setAnchorPoint(ccp(0.5,0))
	setAdaptNode(_createUserBtn)
	_createUserBtn:registerScriptTapHandler(createUserCb)
	menu:addChild(_createUserBtn)

	local sieveBtn = CCMenuItemImage:create(IMG_PATH .. "sieve/sieve_h.png", IMG_PATH .. "sieve/sieve_n.png")
	sieveBtn:setPosition(ccps(495/640, 158/960 ))
	sieveBtn:registerScriptTapHandler(sieveBtnCb)
	setAdaptNode(sieveBtn)
	menu:addChild(sieveBtn)

	createNameBox()

	-- 获得随即名字
	getRandomName()



	return _selectLayer
end
