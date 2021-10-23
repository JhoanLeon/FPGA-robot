transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/PI_CONTROL.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/SC_COUNTER_PWM.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/WHEEL_CONTROLLER.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/SC_REGGENERAL.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/SC_COUNTER.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/qmult.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/qadd.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/PREESCALER.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/moduloPWM.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/Encoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/Wheel_controller {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/Wheel_controller/BB_SYSTEM.v}
vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/RTL_COMPONENTS {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/RTL_COMPONENTS/DIRECTION_DET.v}

vlog -vlog01compat -work work +incdir+C:/Users/USUARIO\ WINDOWS/Desktop/Proyecto\ de\ Grado/FPGA-robot-copia17b/Wheel_controller/simulation/modelsim {C:/Users/USUARIO WINDOWS/Desktop/Proyecto de Grado/FPGA-robot-copia17b/Wheel_controller/simulation/modelsim/TB_SYSTEM.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TB_SYSTEM

add wave *
view structure
view signals
run -all
