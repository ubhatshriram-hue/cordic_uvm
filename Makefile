
# ==============================================================================
# CORDIC UVM MAKEFILE
# ==============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

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
SEED ?= 1

COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

OUT_DIR = log_folder

# ==============================================================================
# REGRESSION TEST LIST
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
# TARGETS
# ==============================================================================

.PHONY: all start compile sim regression all_cov wave clean git

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
# RUN ONE TEST
#
# Normal:
# make sim TESTNAME=angle_0
#
# With mid-reset:
# make sim TESTNAME=angle_0 MID_RESET=1
# ==============================================================================

MID_RESET ?= 0

sim:
	cd $(OUT_DIR) && ./simv \
	-l $(TESTNAME)_simulate.log \
	$(COV_FLAGS) \
	-cm_dir simv.vdb \
	-cm_name $(TESTNAME)_single \
	-cm_log $(TESTNAME)_cm.log \
	-key $(TESTNAME)_ucli.key \
	+fsdbfile+$(TESTNAME).fsdb \
	+UVM_TESTNAME=$(TESTNAME) \
	$(if $(filter 1,$(MID_RESET)),+MID_RESET,) \
	+ntb_random_seed=$(SEED)

# ==============================================================================
# RUN ALL REGRESSION TESTS
# ==============================================================================

regression: compile
	@echo "=========================================================="
	@echo "             CORDIC UVM REGRESSION"
	@echo "=========================================================="
	@echo " Total tests : $(words $(TEST_LIST))"
	@echo " Seed        : $(SEED)"
	@echo "=========================================================="

	@rm -f $(OUT_DIR)/regression_seed_$(SEED).log

	@for test in $(TEST_LIST); do \
		echo ""; \
		echo "##########################################################" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		echo " RUNNING TEST: $$test | SEED: $(SEED)" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		echo "##########################################################" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		(cd $(OUT_DIR) && ./simv \
			$(COV_FLAGS) \
			-cm_dir simv.vdb \
			-cm_name $$test \
			-cm_log $$test\_cm.log \
			-key $$test\_ucli.key \
			+fsdbfile+$$test.fsdb \
			+UVM_TESTNAME=$$test \
			+ntb_random_seed=$(SEED)) \
			2>&1 | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
	done

	@echo "REGRESSION COMPLETED"

# ==============================================================================
# COMPLETE COVERAGE FLOW
#
# 1. Compile
# 2. Create fresh coverage database
# 3. Run selected test with mid-reset
# 4. Run all regression tests normally
# 5. Generate combined coverage report
# ==============================================================================

all_cov: compile
	@echo ""
	@echo "=========================================================="
	@echo "           CORDIC COMPLETE COVERAGE FLOW"
	@echo "=========================================================="
	@echo " Mid-reset test : $(TESTNAME)"
	@echo " Regression     : $(words $(TEST_LIST)) tests"
	@echo " Seed           : $(SEED)"
	@echo "=========================================================="

	@rm -rf $(OUT_DIR)/simv.vdb $(OUT_DIR)/covReport

	@echo ""
	@echo "========== RUNNING SELECTED TEST WITH MID-RESET =========="

	@(cd $(OUT_DIR) && ./simv \
		$(COV_FLAGS) \
		-cm_dir simv.vdb \
		-cm_name midreset_$(TESTNAME) \
		-cm_log midreset_$(TESTNAME)_cm.log \
		-key midreset_$(TESTNAME)_ucli.key \
		+fsdbfile+midreset_$(TESTNAME).fsdb \
		+UVM_TESTNAME=$(TESTNAME) \
		+MID_RESET \
		+ntb_random_seed=$(SEED)) \
		2>&1 | tee $(OUT_DIR)/midreset_$(TESTNAME).log

	@echo ""
	@echo "========== RUNNING NORMAL REGRESSION ==========="

	@rm -f $(OUT_DIR)/regression_seed_$(SEED).log

	@for test in $(TEST_LIST); do \
		echo ""; \
		echo "##########################################################" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		echo " RUNNING TEST: $$test | SEED: $(SEED)" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		echo "##########################################################" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		(cd $(OUT_DIR) && ./simv \
			$(COV_FLAGS) \
			-cm_dir simv.vdb \
			-cm_name $$test \
			-cm_log $$test\_cm.log \
			-key $$test\_ucli.key \
			+fsdbfile+$$test.fsdb \
			+UVM_TESTNAME=$$test \
			+ntb_random_seed=$(SEED)) \
			2>&1 | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
	done

	@echo ""
	@echo "========== GENERATING COMBINED COVERAGE =========="

	cd $(OUT_DIR) && urg -full64 \
		-dir simv.vdb \
		-report covReport \
		-log urg.log

	@echo ""
	@echo "=========================================================="
	@echo "          COVERAGE GENERATION COMPLETED"
	@echo "=========================================================="
	@echo " Mid-reset test : $(TESTNAME)"
	@echo " Regression     : COMPLETED"
	@echo " Coverage       : $(OUT_DIR)/covReport"
	@echo "=========================================================="

# ==============================================================================
# OPEN WAVEFORM
#
# Normal:
# make wave TESTNAME=angle_0
#
# Mid-reset waveform:
# make wave TESTNAME=midreset_angle_0
# ==============================================================================

wave:
	cd $(OUT_DIR) && verdi -ssf $(TESTNAME).fsdb &

# ==============================================================================
# CLEAN ALL GENERATED FILES
# ==============================================================================

clean:
	rm -rf $(OUT_DIR) DVEfiles

# ==============================================================================
# GIT AUTOMATION
# ==============================================================================

git:
	@echo "Enter your git commit message:"; \
	read msg; \
	git add src/ Makefile *.md; \
	git commit -m "$$msg"; \
	git push
