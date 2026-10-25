-- this lowers the captain's shtork above the DH for instrument training
-- functionality enabled by the СИВ-1 switch but not a realistic implementation of the СИВ-1 system

defineProperty("siv1", globalPropertyf("sim/custom/misc/siv1"))

defineProperty("rv_dh_left", globalPropertyf("tu154b2/custom/gauges/alt/radioalt_dh_left"))
defineProperty("rv_needle_left", globalPropertyf("tu154b2/custom/gauges/alt/radioalt_needle_left"))

defineProperty("shtork1", globalPropertyi("tu154b2/custom/switchers/spu_4_source"))
-- defineProperty("shtork2", globalPropertyi("tu154b2/custom/switchers/spu_4_mode"))

-- defineProperty("bus36_volt", globalPropertyf("tu154b2/custom/elec/bus36_volt_left"))

defineProperty("frame_time", globalPropertyf("tu154b2/custom/time/frame_time")) -- flight time

local shtork_command = 0
local shtork_command_last = 0

function update()
	local passed = get(frame_time)
	-- local power = get(bus36_volt) > 30

    if get(siv1)>0 then
        if get(rv_needle_left) > get(rv_dh_left) then
            shtork_command = shtork_command + passed*8
        else
            shtork_command = shtork_command - passed*8
        end
    else
        shtork_command = shtork_command - passed*8
    end

    if shtork_command>1 then shtork_command = 1 end
    if shtork_command<0 then shtork_command = 0 end

    if shtork_command ~= shtork_command_last then
        if shtork_command > 0.99 then
            set(shtork1, 2)
            -- set(shtork2, 2)
        elseif shtork_command > 0.5 then
            set(shtork1, 1)
            -- set(shtork2, 1)
        else
            set(shtork1, 0)
            -- set(shtork2, 0)
        end
    end

    shtork_command_last = shtork_command

end
