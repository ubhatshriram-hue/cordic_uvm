
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
# REGRESSION TEST LIST (28 TESTS)
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
	boundary_test \
	angle_sweep \
	multiplication_sweep

# ==============================================================================
# TARGETS
# ==============================================================================

.PHONY: all start compile sim regression wave clean git

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
# ==============================================================================

sim:
	cd $(OUT_DIR) && ./simv \
		-l $(TESTNAME)_simulate.log \
		$(COV_FLAGS) \
		-cm_dir simv.vdb \
		-cm_name $(TESTNAME) \
		-cm_log $(TESTNAME)_cm.log \
		+fsdbfile+$(TESTNAME).fsdb \
		+UVM_TESTNAME=$(TESTNAME) \
		+ntb_random_seed=$(SEED)

# ==============================================================================
# RUN ALL REGRESSION TESTS
# ==============================================================================

regression: compile
	@echo "=========================================================="
	@echo "             CORDIC UVM REGRESSION"
	@echo "=========================================================="
	@echo " Total tests : $(words $(TEST_LIST))"
	@echo " Seed       : $(SEED)"
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
			+fsdbfile+$$test.fsdb \
			+UVM_TESTNAME=$$test \
			+ntb_random_seed=$(SEED)) \
			2>&1 | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
	done

	@echo ""
	@echo "REGRESSION COMPLETED"

# ==============================================================================
# OPEN WAVEFORM
# ==============================================================================

wave:
	cd $(OUT_DIR) && verdi -ssf $(TESTNAME).fsdb &

# ==============================================================================
# CLEAN
# ONLY make clean clears the coverage database.
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
