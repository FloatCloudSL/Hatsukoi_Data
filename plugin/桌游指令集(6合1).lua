--多款规则掷骰指令合集
--作者:安研色Shiki
--版本:v1.1
--内含指令:.rdc(DND).rsr(Shadowrun).rdx(双重十字).rnc(永夜后日谈).rfc(祸不单行).rbh(小黑屋)
--本文件仅供学习交流之用
msg_order = {}

function intostring(num)
    if(num==nil)then
        return ""
    end
    return string.format("%d",num)
end

--DND
function roll_d20(msg)
    local rest=string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$", 5)
    if(rest=="")then
        return [[
D20检定:.rdc
.rdc(B/P) (+/-[加值]) ([检定理由]) ([成功阈值])
参数[优/劣势骰]:可选，B=2D20取大，P=2D20取小
参数[加值]:可选，加值最后修正到D20结果上
参数[检定理由]:可选，将显示在回执语句中
参数[成功阈值]:可选，将与掷骰结果比较，返回成功或失败
空参返回本段说明文字]]
    end
    local bonus,sign,rest = string.match(rest,"^[%s]*([bBpP]?)[%s]*([+-]?)(.*)$")
    local addvalue = 0
    local modify = ""
    --加减符号判断有无加值
    if(sign ~= "")then
        modify,rest = string.match(rest,"^([%d]+)[%s]*(.*)$")
        if(modify==nil or modify=="")
        then
            return "请{pc}输入正确的加值"
        end
        addvalue = tonumber(modify)
        if(sign=='-')
        then
            addvalue = addvalue*-1;
        end
    end
    local skill,dc = string.match(rest,"^[%s]*(.-)[%s]*([%d]*)$")
    local dc = tonumber(dc)
    if(dc~=nil)then
        if(dc<1)then
            return "这你要怎么才能失败啊？"
        elseif(dc>99)then
            return "这你要怎么才能成功啊？"
        end
    end
    local die = ranint(1,20)
    local selected = die
    local res
    --考虑优势骰/劣势骰
    if(bonus=="")then
        res="D20"..sign..modify.."="..intostring(die)..sign..modify
    else
        local another=ranint(1,20)
        bonus=string.upper(bonus)
        if((another>die and bonus=="B")or(another<die and bonus=="P"))then
            selected=another
        end
        res=bonus.."("..intostring(die)..','..intostring(another)..")"..sign..modify.."->"..intostring(selected)..sign..modify
    end
    local strReply = "{pc}进行"..skill.."检定:"..res
    local final=selected+addvalue
    if(addvalue~=0)then
        strReply=strReply.."="..intostring(final)
    end
    if(dc==nil)then
        --对成功与否不做判定
    elseif(final>dc)
    then 
        strReply=strReply..'>'..intostring(dc).." {strRollRegularSuccess}"
    elseif(final<dc)
    then
        strReply=strReply..'<'..intostring(dc).." {strRollFailure}"
    else
        strReply=strReply..'='..intostring(dc).." {strRollRegularSuccess}"
    end
    return strReply
end
msg_order[".rdc"] = "roll_d20"

--暗影狂奔shadowrun
function roll_shadowrun(msg)
    local cnt = tonumber(string.match(msg.fromMsg,"%d+",5))
    if(not cnt)
    then
        return "shadowrun检定:.rsr[骰数] 出5/6视为命中\n出1过半视为失误"
    end
    local res="{pc}掷骰"..cnt.."D6: "
    cnt = tonumber(cnt)
    if(cnt<1)
    then
        return "{strZeroDiceErr}"
    elseif(cnt>100)
    then
        return "{strDiceTooBigErr}"
    else
        local cntSuc=0
        local cntFail=0
        local pool={}
        local glitch=""
        for times=1,cnt do
            local die=ranint(1,6)
            if(die>=5)then
                cntSuc = cntSuc + 1
            elseif(die==1)then
                cntFail = cntFail + 1
            end
            table.insert(pool,intostring(die))
        end
        if(cntFail > cnt/2)then
            glitch = " {strGlitch}"
        end
        local reply=res..table.concat(pool,'+').."->"..intostring(cntSuc)..glitch
        return reply
    end
end
msg_order[".rsr"] = "roll_shadowrun"

--双重十字DoubleCross
function roll_doubleX(msg)
    local resCnt, rest = string.match(msg.fromMsg,"(%d+)(.*)",5)
    local resCritical = string.match(rest,"[cC](%d+)")
    if(not resCnt)
    then
        return "双重十字检定:.rdx[骰数]c[暴击值]\n结果取[骰数]个D10的最高点数，暴击则重骰并累加点数\n暴击值可提前设定(如.st暴击值8)，默认10\n重骰超过30次将强行抛出"
    end
    local res="{pc}掷骰DX"..resCnt
    local cnt, critical_val = tonumber(resCnt),tonumber(resCritical) or tonumber(getPlayerCardAttr(msg.fromQQ, msg.fromGroup,"暴击值",10)) or 10
    if(critical_val<2)then critical_val=2 end
    local res=res.."c"..intostring(critical_val).."="
    if(cnt<1)
    then
        return "{strZeroDiceErr}"
    elseif(cnt>100)
    then
        return "{strDiceTooBigErr}"
    end
    local res_pool={}
    local sum = 0
    while(cnt>0)do
        if(#res_pool>30)then
            return "运算循环已突破30级奇点，{self}运算中止!\n待重骰骰数:"..intostring(cnt)
        end
        local dieMax=0
        local cntCrt=0
        local die_pool={}
        for times=1,cnt do
            local die=ranint(1,10)
            if(die>=critical_val)then
                cntCrt = cntCrt + 1
                dieMax = 10
            elseif(die>dieMax)then
                dieMax = die
            end
            table.insert(die_pool,intostring(die))
        end
        sum = sum + dieMax
        cnt = cntCrt
        table.insert(res_pool,"DX{"..table.concat(die_pool,"+").."}")
    end
    local reply=res..table.concat(res_pool,"+").."\n="..intostring(sum)
    return reply
end
msg_order[".rdx"] = "roll_doubleX"

--永夜后日谈
function roll_nc(msg)
    local pos=5;
    local modify = string.match(msg.fromMsg,"([+-][%d]+)[^%d]*",4)--"^[%s]*([+-][%d]+)[%s]*$",4)
    local addvalue = 0
    local sign = ""
    if(modify ~= nil)
    then
        sign = string.sub(modify,1,1)
        modify = string.sub(modify,2)
        addvalue = tonumber(modify)
        if(sign=='-')
        then
            addvalue=addvalue*-1;
        end
    else
        modify = ""
    end
    pos = pos + string.len(modify)
    local skill = string.match(msg.fromMsg,"^[%s%d]*(.-)[%s%d]*$",pos)
    pos = pos + string.len(skill)
    local res=ranint(1,10)
    local strReply="{pc}进行攻击判定:D10"..sign..modify.."="..intostring(res)..sign..modify
    local final=res+addvalue
    if(addvalue~=0)then
        strReply=strReply.."="..intostring(final)
    end
    if(final<=1)
    then 
        strReply=strReply.." {strRollFumble}"
    elseif(final<=5)
    then
        strReply=strReply.." {strRollFailure}"
    elseif(final<=6)
    then
        strReply=strReply.." 命中自选部位"
    elseif(final<=7)
    then
        strReply=strReply.." 命中足部"
    elseif(final<=8)
    then
        strReply=strReply.." 命中躯干"
    elseif(final<=9)
    then
        strReply=strReply.." 命中手臂"
    elseif(final<=10)
    then
        strReply=strReply.." 命中头部"
    else
        strReply=strReply.." {strRollCriticalSuccess}"
    end
    return strReply,""
end
msg_order[".rnc"] = "roll_nc"

--祸不单行
function roll_fiasco(msg)
    local rest = string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$", 5)
    if(rest=="")
    then
        return "祸不单行检定.rfc bXwY 掷XD6白骰+YD6黑骰，相消取颜色和结果"
    end
    local alpBlack,cntBlack = string.match(rest,"([bB])[%s]*(%d*)")
    local alpWhite,cntWhite = string.match(rest,"([wW])[%s]*(%d*)")
    if(alpBlack)then
        if(cntBlack=="")then
            cntBlack=1
        else
            cntBlack=tonumber(cntBlack)
        end
    else
        cntBlack=0
    end
    if(alpWhite)then
        if(cntWhite=="")then
            cntWhite=1
        else
            cntWhite=tonumber(cntWhite)
        end
    else
        cntWhite=0
    end
    if(cntBlack==0 and cntWhite==0)
    then
        return "{strZeroDiceErr}"
    elseif(cntBlack+cntWhite>100)
    then
        return "{strDiceTooBigErr}"
    else
        local poolBlack, poolWhite={},{}
        local resBlack, resWhite, resTotal="","",""
        local sumBlack, sumWhite, sumTotal=0,0,0
        if(cntBlack>0)then
            for times=1, cntBlack do
                local die = ranint(1,6)
                sumBlack = sumBlack + die
                table.insert(poolBlack,intostring(die))
            end
            resBlack="\n黑"..cntBlack.."D6="..table.concat(poolBlack,'+').."="..intostring(sumBlack).."黑"
        end
        if(cntWhite>0)then
            for times=1, cntWhite do
                local die = ranint(1,6)
                sumWhite = sumWhite + die
                table.insert(poolWhite,intostring(die))
            end
            resWhite="\n白"..cntWhite.."D6="..table.concat(poolWhite,'+').."="..intostring(sumWhite).."白"
        end
        if(cntBlack>0 and cntWhite>0)then
            if(sumBlack>sumWhite)then
                resTotal="\n总计黑"..intostring(sumBlack-sumWhite)
            elseif(sumBlack<sumWhite)then
                resTotal="\n总计白"..intostring(sumWhite-sumBlack)
            else
                resTotal="\n总计0"
            end
        end
        local reply="祸不单行的{pc}:"..resBlack..resWhite..resTotal
        return reply,""
    end
end
msg_order[".rfc"] = "roll_fiasco"

--小黑屋
function roll_blackhouse(msg)
    if(msg.fromMsg==".rbh")
    then
        return "山屋惊魂检定.rbh[骰数] 每粒骰子出目0~2"
    end
    local cnt = tonumber(string.match(msg.fromMsg,"%d+",5))
    if(cnt<1)
    then
        return "{strZeroDiceErr}"
    elseif(cnt>100)
    then
        return "{strDiceTooBigErr}"
    else
        local res="{pc}掷骰"..cnt.."粒:"
        local sum=0
        local pool={}
        for times=1,cnt do
            local die=ranint(0,2)
            sum = sum + die
            table.insert(pool,intostring(die))
        end
        local reply=res..table.concat(pool,'+').."="..intostring(sum)
        return reply,""
    end
end
msg_order[".rbh"] = "roll_blackhouse"