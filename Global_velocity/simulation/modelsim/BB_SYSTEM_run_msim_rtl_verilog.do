transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_complex/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_complex/rtl/SC_REGGENERAL.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_complex/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_complex/rtl/SC_STATEMACHINE_GLOBAL_VEL.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_complex/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_complex/rtl/SC_GLOBAL_VELOCITY.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_complex/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_complex/rtl/core_cordic.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_complex/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_complex/rtl/qmults.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_complex/rtl {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_complex/rtl/qadd.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_complex {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_complex/BB_SYSTEM.v}

vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/Test_complex/simulation/modelsim {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/Test_complex/simulation/modelsim/TB_SYSTEM.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TB_SYSTEM

add wave *
view structure
view signals
run -all