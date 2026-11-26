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
	multiplication_sweep\
err_ang_test

# ==============================================================================
# TARGETS
# ==============================================================================

.PHONY: all help start compile sim regression report wave clean git

.DEFAULT_GOAL := all

all: sim

# ==============================================================================
# HELP
# ==============================================================================

help:
	@echo ""
	@echo "============== CORDIC UVM MAKE OPTIONS =============="
	@echo " make                         : Compile + run angle_0"
	@echo " make compile                  : Compile testbench"
	@echo " make sim TESTNAME=<test>      : Run single test"
	@echo " make sim TESTNAME=<test> SEED=<n>"
	@echo "                              : Run test with seed"
	@echo " make regression              : Run all 28 tests"
	@echo " make report                  : Generate coverage HTML report"
	@echo " make wave TESTNAME=<test>     : Open FSDB waveform"
	@echo " make start                   : Start Synopsys environment"
	@echo " make clean                   : Clear generated files + coverage"
	@echo " make git                     : Commit and push"
	@echo "=================================================="
	@echo ""

# ==============================================================================
# START SYNOPSYS ENVIRONMENT
# ==============================================================================

start:
	/bin/csh -c "source /fetools/synopsys/source/source.sh && exec /bin/csh"

# ==============================================================================
# COMPILE
# Does not intentionally clear coverage database.
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
# Runs one test and refreshes coverage report.
# ==============================================================================

sim: compile
	@sim_status=0; \
	(cd $(OUT_DIR) && ./simv \
		-l $(TESTNAME)_simulate.log \
		$(COV_FLAGS) \
		-cm_dir simv.vdb \
		-cm_name $(TESTNAME) \
		-cm_log $(TESTNAME)_cm.log \
		+fsdbfile+$(TESTNAME).fsdb \
		+UVM_TESTNAME=$(TESTNAME) \
		+ntb_random_seed=$(SEED)) || sim_status=$$?; \
	$(MAKE) report; \
	exit $$sim_status

# ==============================================================================
# RUN ALL REGRESSION TESTS
# Coverage is accumulated. Database is NOT cleared.
# Continues running even if a test fails.
# ==============================================================================

regression: compile
	@failed=0; \
	failed_tests=""; \
	rm -f $(OUT_DIR)/regression_seed_$(SEED).log; \
	echo "=========================================================="; \
	echo "             CORDIC UVM REGRESSION"; \
	echo "=========================================================="; \
	echo " Total tests : $(words $(TEST_LIST))"; \
	echo " Seed        : $(SEED)"; \
	echo "=========================================================="; \
	for test in $(TEST_LIST); do \
		echo ""; \
		echo "##########################################################" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		echo " RUNNING TEST: $$test | SEED: $(SEED)" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		echo "##########################################################" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		if (cd $(OUT_DIR) && ./simv \
			$(COV_FLAGS) \
			-cm_dir simv.vdb \
			-cm_name $$test \
			-cm_log $$test\_cm.log \
			+fsdbfile+$$test.fsdb \
			+UVM_TESTNAME=$$test \
			+ntb_random_seed=$(SEED)) \
			2>&1 | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; then \
			echo "PASS: $$test" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
		else \
			echo "FAIL: $$test" | tee -a $(OUT_DIR)/regression_seed_$(SEED).log; \
			failed=1; \
			failed_tests="$$failed_tests $$test"; \
		fi; \
	done; \
	echo ""; \
	echo "============== REGRESSION SUMMARY =============="; \
	if [ $$failed -eq 0 ]; then \
		echo "ALL TESTS PASSED"; \
	else \
		echo "FAILED TESTS: $$failed_tests"; \
	fi; \
	echo "============================================"; \
	$(MAKE) report; \
	if [ $$failed -ne 0 ]; then exit 1; fi

# ==============================================================================
# GENERATE COVERAGE REPORT
# Uses accumulated coverage database.
# ==============================================================================

report:
	urg -full64 \
		-dir $(OUT_DIR)/simv.vdb \
		-report $(OUT_DIR)/covReport \
		-log $(OUT_DIR)/urg.log

# ==============================================================================
# OPEN WAVEFORM
# ==============================================================================

wave:
	cd $(OUT_DIR) && verdi -ssf $(TESTNAME).fsdb &

# ==============================================================================
# CLEAN
# ONLY make clean clears accumulated coverage.
# ==============================================================================

clean:
	rm -rf $(OUT_DIR) DVEfiles simv.vdb csrc

# ==============================================================================
# GIT AUTOMATION
# ==============================================================================

git:
	@echo "Enter your git commit message:"; \
	read msg; \
	git add src/ Makefile *.md; \
	git commit -m "$$msg"; \
	git push
