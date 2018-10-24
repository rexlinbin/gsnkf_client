-- Filename: config_kimi.lua
-- Author: lei yang
-- Date: 2014-2-20
-- Purpose: android kimi(曹操之野望) 平台配置
module("config", package.seeall)

--local g_web_domain_name = "http://apitest.fun.kimi.com.tw/"--"http://api.fun.kimi.com.tw/"
local g_web_domain_name_debug = "http://210.73.215.68/"


-- 更改 服务基础URL
local g_web_domain_name = "http://172.16.150.129/"
-- 服务器列表URL
local g_server_list_url = "http://172.16.150.129/phone/serverlistnotice6/"
-- 检查版本URL = g_web_domain_name .. "phone/get3dVersion?"

-- 更改 下载更新包URL
local g_web_download_url = "http://116.196.125.56/f3_az/"

-- 更改 账号登录URL
local g_acc_login_url = "http://172.16.150.129:8881/phone/login/"



loginInfoTable = {}

function getFlag( ... )
	return "kmocphone"
end


function getServerListUrl( ... )
	-- 服务器列表URL
 	return g_server_list_url .. "?".. Platform.getUrlParam()
end  

--[[
function getPidUrl( sessionid )
	local url = g_web_domain_name.."phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?klsso=" .. sessionid .. "&time=".. BTUtil:getSvrTimeInterval() .. Platform.getUrlParam().."&bind=" .. g_dev_udid
 	return postString
end 
--]]

function getOther_pl( ... )
	return "zyxphone"
end

function getPidUrl( sessionid )
	local url = g_acc_login_url
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?sid=" .. sessionid .. "&uin=".. Platform.getUin() .. Platform.getUrlParam().."&bind=" .. g_dev_udid .."&other_pl=" .. getOther_pl()
 	return postString
end 


function getLanguage( ... )
 	return "tw"
end 

function getDomain( ... )
 	return g_web_domain_name
end 

function getDownUrl( ... )
	return g_web_download_url
end

function getHashUrl( )
 	return g_web_domain_name.."phone/getHash/"
end 

function getAdShowUrl( ... )
 	return g_web_domain_name.. "phone/adshow?pl=kmocphone&os=android&gn=sanguo&version="
end 

function getAppId( ... )
	return "104964"
end

function getAppKey( ... )
	return "r0bC40WXQ8uVSJjRjWLMY9rB"
end

function getName( ... ) 
	return "社區福利"
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end

function getGroupParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end

--[[
function getUserInfoParam( gameState )
	require "script/model/user/UserModel"
    require "script/ui/login/ServerList"
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
    dict:setObject(CCString:create(ServerList.getSelectServerInfo().name),"groupName")
    dict:setObject(CCString:create(loginInfoTable.newuser),"newuser")
    dict:setObject(CCString:create(loginInfoTable.uid),"uid")
    if(tonumber(gameState) == 1)then
       	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
       	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
       	--print("gameState = ",gameState)
       	--print("appUid = ",UserModel.getUserUid())
       	--print("appUname = ",UserModel.getUserName())
	end
	--print("gameState = ",gameState)
	return dict
end
--]]

function getShareInfoParam( dict )
    local feed = GetLocalizeStringBy("key_1647")
    local caption = "《曹操之野望》下一戰，英雄由你來當！"
    local description = GetLocalizeStringBy("key_1851")
    local link = "https://play.google.com/store/apps/details?id=com.kimi.ggplay.fknsg"
    local picture = "http://static.kimi.com.tw/web/nsg/fb_nsg_icon.png"

    dict:setObject(CCString:create(feed),"feed")
    dict:setObject(CCString:create(caption),"caption")
    dict:setObject(CCString:create(description),"description")
    dict:setObject(CCString:create(link),"link")
    dict:setObject(CCString:create(picture),"picture")

	return dict
end

function getPayTypeParam( ... )
    return 4
end
function getPayMoneyDesc( ... )
    return GetLocalizeStringBy("key_1031")
end
function getLogoLayer( ... )
    return nil
end 
function getBgLayer( ... )
    return nil
end 
function getShareType( ... )
    return "Facebook"
end 
function isNeedAdShow( ... )
    return false
end 
function isNeedUserSenter( ... )
    return true
end 
function isNeedInitPlGroup( ... )
    return true
end

--[[
function setLoginInfo( xmlTable )
	print("setLoginInfo")
	loginInfoTable.uid = xmlTable:find("uid")[1]
	loginInfoTable.newuser = xmlTable:find("newuser")[1]
end
--]]

--debug conifg
function getServerListUrl_debug( ... )
 	return g_web_domain_name_debug .. "phone/serverlistnotice/?pl=kmphone&gn=sanguo&os=android"
end 


function getPidUrl_debug( sessionid )
	local url = g_web_domain_name_debug.."phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?klsso=" .. sessionid .."&time=".. BTUtil:getSvrTimeInterval() .. Platform.getUrlParam().."&bind=" .. g_dev_udid
 	return postString
end 



function getDomain_debug( ... )
 	return g_web_domain_name_debug
end 

function getAppId_debug( ... )
	return "104964"
end

function getAppKey_debug( ... )
	return "r0bC40WXQ8uVSJjRjWLMY9rB"
end


kLoginsStateNotLogin="0"
kLoginsStateUDIDLogin="1"
kLoginsStateZYXLogin="2"
function getLoginState( ... )
	if(CCUserDefault:sharedUserDefault():getStringForKey("loginState") == nil or CCUserDefault:sharedUserDefault():getStringForKey("loginState") == "")then
		return kLoginsStateNotLogin
	end
	return CCUserDefault:sharedUserDefault():getStringForKey("loginState")
end



function getLoginUrl( username,password )
	return g_acc_login_url .. "?".. Platform.getUrlParam().."&action=login&username=" .. username .. "&password=" .. password .. "&ext=" .. "&bind=" .. g_dev_udid .."&other_pl=" .. getOther_pl()
end


function getRegisterUrl( )
	local registerUrl 
	if  g_debug_mode then
		registerUrl = "http://124.205.151.82/phone/login/?action=register" .. Platform.getUrlParam() .."&other_pl=" .. getOther_pl()
	else
		registerUrl = g_acc_login_url .. "?action=register".. Platform.getUrlParam() .."&other_pl=" .. getOther_pl()
	end
	return registerUrl
end

function getChangePasswordUrl( )
	local renewpassUrl = ""
	if  Platform.isDebug() then
		renewpassUrl = "http://124.205.151.82/phone/login/?".. Platform.getUrlParam().."&action=renewpass" .."&other_pl=" .. getOther_pl()
	else
		renewpassUrl = g_acc_login_url .. "?".. Platform.getUrlParam().."&action=renewpass" .."&other_pl=" .. getOther_pl()
	end
	return renewpassUrl
end

