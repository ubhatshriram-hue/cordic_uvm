
SOURCE_FILES = src/tb/globals/cordic_package.sv src/tb/cordic_top.sv

INCDIRS = \
+incdir+src/tb \
+incdir+src/dut \
+incdir+src/tb/globals \
+incdir+src/tb/env/act_agent \
+incdir+src/tb/env/pass_agent \
+incdir+src/tb/env \
+incdir+src/tb/sequences \
+incdir+src/tb/test

TESTNAME ?= angle_0
SEED ?= 1234
JOBS ?= 4

COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert
OUT_DIR = log_folder

TEST_LIST = \
angle_0 \
pos_pos_test \
quad1_test \
quad2_test \
quad3_test \
quad4_test \
repeat_same_test \
repeat_diff_test \
neg_neg_test \
pos_neg_test \
neg_pos_test \
repeat_mul_test \
angle_mul_angle_test \
mul_ang_mul_test \
random_angle_test \
random_mul_test \
angle_max_test \
angle_270_test \
angle_90_test \
angle_180_test \
zero_a_test \
zero_b_test \
max_pos_test \
min_neg_test \
max_min_test \
boundary_test

REGRESS_TARGETS = $(foreach t,$(TEST_LIST),regress_run_$(t))

.PHONY: all start compile sim regression cov wave clean git
.DEFAULT_GOAL := all

all: compile sim

start:
	/bin/csh -c "source /fetools/synopsys/source/source.sh && exec /bin/csh"

compile:
	mkdir -p $(OUT_DIR)
	vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm-1.2 \
	-debug_access+all -kdb $(COV_FLAGS) $(INCDIRS) \
	-Mdir=$(OUT_DIR)/csrc -o $(OUT_DIR)/simv \
	-cm_dir $(OUT_DIR)/simv.vdb \
	-cm_log $(OUT_DIR)/cm_compile.log \
	-l $(OUT_DIR)/compile.log $(SOURCE_FILES)

sim:
	cd $(OUT_DIR) && ./simv -l $(TESTNAME)_simulate.log \
	$(COV_FLAGS) -cm_dir simv.vdb -cm_name $(TESTNAME) \
	-cm_log cm_sim.log -key ucli.key \
	+fsdbfile+dump.fsdb \
	+UVM_TESTNAME=$(TESTNAME) \
	+ntb_random_seed=$(SEED)

regression: compile
	@echo "=================================================="
	@echo " CORDIC REGRESSION"
	@echo " TESTS : $(words $(TEST_LIST))"
	@echo " SEED : $(SEED)"
	@echo " JOBS : $(JOBS)"
	@echo "=================================================="
	-$(MAKE) -k -j$(JOBS) $(REGRESS_TARGETS)
	@echo "=================================================="
	@echo " REGRESSION COMPLETED"
	@echo "=================================================="

$(REGRESS_TARGETS): regress_run_%:
	@echo "Running $* with seed $(SEED)"
	@cd $(OUT_DIR) && ./simv \
	-l $*_$(SEED)_simulate.log \
	$(COV_FLAGS) \
	-cm_dir simv.vdb \
	-cm_name $*_$(SEED) \
	-cm_log $*_$(SEED)_cm.log \
	-key $*_$(SEED)_ucli.key \
	+fsdbfile+$*_$(SEED).fsdb \
	+UVM_TESTNAME=$* \
	+ntb_random_seed=$(SEED) > /dev/null

cov:
	cd $(OUT_DIR) && urg -full64 \
	-dir simv.vdb -report covReport -log urg.log

wave:
	cd $(OUT_DIR) && verdi -ssf dump.fsdb &

clean:
	rm -rf $(OUT_DIR)/simv* \
	$(OUT_DIR)/csrc* \
	$(OUT_DIR)/*.log \
	$(OUT_DIR)/*.vpd \
	$(OUT_DIR)/*.fsdb \
	$(OUT_DIR)/*.key \
	$(OUT_DIR)/*.vdb \
	$(OUT_DIR)/verdiLog \
	$(OUT_DIR)/novas* \
	$(OUT_DIR)/covReport \
	DVEfiles

git:
	@echo "Enter your git commit message:"; \
	read msg; \
	git add src/ Makefile *.md; \
	git commit -m "$$msg"; \
	git push
