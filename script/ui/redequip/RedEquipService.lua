-- FileName: RedEquipService.lua 
-- Author: llp
-- Date: 15/10/30
-- Purpose: 红色装备进阶后端接口


module("RedEquipService", package.seeall)
-- /**
--  * 进阶装备
--  * 品质变化，模板id不变
--  *
--  * @param int $itemId			物品id
--  * @param int $itemIds			消耗的物品id组
--  * @return array
--  * <code>
--  * {
--  * 		'armReinforceLevel':强化等级
-- 	 * 		'armReinforceCost':强化费用
-- 	 * 		'armDevelop':装备进阶等级
-- 	 * 		'armPotence':潜能属性数组
-- 	 * 		{
-- 	 * 			$attrId => $attrValue
-- 	 * 		}
-- 	 * 		'armFixedPotence':洗练属性数组
-- 	 * 		{
-- 	 * 			$attrId => $attrValue
-- 	 * 		}
--  * }
--  * </code>
--  */
function develop(p_itemId, p_itemIdTab, p_callBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			print("--------后端返回数据--develop-----------")
			print_t(dictData)
			if(p_callBack ~= nil)then
				p_callBack(dictData.ret)
			end
		end
	end
	local args = Network.argsHandlerOfTable({p_itemId, p_itemIdTab})
	Network.rpc(requestFunc,"forge.developArm","forge.developArm",args,true)
end