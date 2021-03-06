transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_fixedpoint/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_fixedpoint/rtl/qmults.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_fixedpoint/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_fixedpoint/rtl/qdiv.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_fixedpoint/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_fixedpoint/rtl/qadd.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_fixedpoint {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_fixedpoint/BB_SYSTEM.v}

vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_fixedpoint/simulation/modelsim {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_fixedpoint/simulation/modelsim/TB_SYSTEM.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TB_SYSTEM

add wave *
view structure
view signals
run -all
