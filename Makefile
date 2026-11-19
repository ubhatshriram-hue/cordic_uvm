
# ==============================================================================
# CORDIC UVM MAKEFILE
# ==============================================================================

SOURCE_FILES = \
	src/tb/globals/cordic_package.sv \
	src/tb/cordic_top.sv

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

SEED = 1

COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

OUT_DIR = log_folder

# ==============================================================================
# ALL 28 TESTS
# ==============================================================================

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

# ==============================================================================
# DEFAULT TARGET
# ==============================================================================

.PHONY: all start compile sim regression cov wave clean git

.DEFAULT_GOAL := all

all: compile sim

# ==============================================================================
# START SYNOPSYS ENVIRONMENT
# ==============================================================================

start:
	/bin/csh -c "source /fetools/synopsys/source/source.sh && exec /bin/csh"

# ==============================================================================
# COMPILE
# ==============================================================================

compile:
	mkdir -p $(OUT_DIR)
	vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm-1.2 \
	-debug_access+all -kdb $(COV_FLAGS) $(INCDIRS) \
	-Mdir=$(OUT_DIR)/csrc -o $(OUT_DIR)/simv \
	-cm_dir $(OUT_DIR)/simv.vdb \
	-cm_log $(OUT_DIR)/cm_compile.log \
	-l $(OUT_DIR)/compile.log $(SOURCE_FILES)

# ==============================================================================
# RUN ONE TEST MANUALLY
# ==============================================================================

sim:
	cd $(OUT_DIR) && ./simv \
	-l $(TESTNAME)_simulate.log \
	$(COV_FLAGS) \
	-cm_dir simv.vdb \
	-cm_name $(TESTNAME) \
	-cm_log cm_sim.log \
	-key ucli.key \
	+fsdbfile+dump.fsdb \
	+UVM_TESTNAME=$(TESTNAME) \
	+ntb_random_seed=$(SEED)

# ==============================================================================
# REGRESSION - ALL 28 TESTS, SEED = 1, FULL OUTPUT IN TERMINAL AND ONE LOG
# ==============================================================================

regression: compile
	@echo "=========================================================="
	@echo "             CORDIC UVM REGRESSION"
	@echo "=========================================================="
	@echo " Total tests : $(words $(TEST_LIST))"
	@echo " Seed       : $(SEED)"
	@echo " Mode       : Sequential"
	@echo " Full log   : $(OUT_DIR)/regression_seed_1.log"
	@echo "=========================================================="
	@rm -f $(OUT_DIR)/regression_seed_1.log
	@for test in $(TEST_LIST); do \
		echo ""; \
		echo "##########################################################" | tee -a $(OUT_DIR)/regression_seed_1.log; \
		echo " RUNNING TEST: $$test | SEED: $(SEED)" | tee -a $(OUT_DIR)/regression_seed_1.log; \
		echo "##########################################################" | tee -a $(OUT_DIR)/regression_seed_1.log; \
		cd $(OUT_DIR) && ./simv \
			$(COV_FLAGS) \
			-cm_dir simv.vdb \
			-cm_name $$test \
			-cm_log $$test\_cm.log \
			-key $$test\_ucli.key \
			+fsdbfile+$$test.fsdb \
			+UVM_TESTNAME=$$test \
			+ntb_random_seed=$(SEED) 2>&1 | tee -a regression_seed_1.log; \
		cd ..; \
	done
	@echo ""; \
	echo "=========================================================="; \
	echo "             REGRESSION COMPLETED"; \
	echo "             ALL 28 TESTS EXECUTED"; \
	echo "             SEED = $(SEED)"; \
	echo "             LOG = $(OUT_DIR)/regression_seed_1.log"; \
	echo "=========================================================="

# ==============================================================================
# COVERAGE REPORT
# ==============================================================================

cov:
	cd $(OUT_DIR) && urg -full64 \
	-dir simv.vdb \
	-report covReport \
	-log urg.log

# ==============================================================================
# OPEN WAVEFORM IN VERDI
# ==============================================================================

wave:
	cd $(OUT_DIR) && verdi -ssf dump.fsdb &

# ==============================================================================
# CLEAN GENERATED FILES
# ==============================================================================

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

# ==============================================================================
# GIT AUTOMATION
# ==============================================================================

git:
	@echo "Enter your git commit message:"; \
	read msg; \
	git add src/ Makefile *.md; \
	git commit -m "$$msg"; \
	git push
