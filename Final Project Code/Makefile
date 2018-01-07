FILES = top.sv parking.v
FLAGS = -sverilog -debug_all

run:	simv
	./simv -l simv.log -svseed random

gui:	simv
	./simv -gui

simv:	${FILES}
	vcs ${FLAGS} ${FILES}


DIR = $(shell basename `pwd`)
tar:	clean
	cd ..;tar cvf ${DIR}.tar ${DIR}

clean:
	@rm -rf csrc simv* *.tcl *.vpd .res* ucli* .ucli* *.old *.txt *.db
	@rm -rf *.log *~ */*~ .*/*~
