rm -rf run
mkdir run
cp .synopsys_dc.setup run/
cd run

rm -rf work
mkdir work

rm -rf ../report
mkdir ../report

source /eda/scripts/init_design_vision
design_vision -f ../synfile.tcl | tee ../report/dc_shell-xg-t.rep

