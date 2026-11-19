# CORDIC UVM Makefile — Single Seed Regression

```makefile
# ==============================================================================
# CORDIC UVM Makefile
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

COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

OUT_DIR = log_folder

# ==============================================================================
# Regression test list (28 tests)
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
# Regression variables
# ==============================================================================

SEED ?= 1234
JOBS ?= 4

REGRESS_TARGETS = $(foreach t,$(TEST_LIST),regress_run_$(t))

.PHONY: all start compile sim regression wave clean git

.DEFAULT_GOAL := all

# ==============================================================================
# 1. Default flow
# ==============================================================================

all: compile sim

# ==============================================================================
# 2. Start Synopsys environment
# ==============================================================================

start:
	/bin/csh -c "source /fetools/synopsys/source/source.sh && exec /bin/csh"

# ==============================================================================
# 3. Compile
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
# 4. Run single test
# ==============================================================================

sim:
	cd $(OUT_DIR) && ./simv -l $(TESTNAME)_simulate.log \
	$(COV_FLAGS) -cm_dir simv.vdb -cm_name $(TESTNAME) \
	-cm_log cm_sim.log -key ucli.key \
	+fsdbfile+dump.fsdb \
	+UVM_TESTNAME=$(TESTNAME) \
	+ntb_random_seed=$(SEED)

# ==============================================================================
# 5. Run all 28 tests with one seed
# ==============================================================================

regression: compile
	@echo "=========================================================="
	@echo " CORDIC UVM REGRESSION"
	@echo " TESTS : $(words $(TEST_LIST))"
	@echo " SEED : $(SEED)"
	@echo " JOBS : $(JOBS)"
	@echo "=========================================================="
	-$(MAKE) -k -j$(JOBS) $(REGRESS_TARGETS)
	@echo "=========================================================="
	@echo " REGRESSION COMPLETED"
	@echo "=========================================================="

# ==============================================================================
# 6. Individual regression test
# ==============================================================================

$(REGRESS_TARGETS): regress_run_%:
	@echo "-> Running $* [Seed: $(SEED)]"
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

# ==============================================================================
# 7. Coverage report
# ==============================================================================

cov:
	cd $(OUT_DIR) && urg -full64 \
	-dir simv.vdb -report covReport -log urg.log

# ==============================================================================
# 8. Waveform
# ==============================================================================

wave:
	cd $(OUT_DIR) && verdi -ssf dump.fsdb &

# ==============================================================================
# 9. Clean
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
# 10. Git
# ==============================================================================

git:
	@echo "Enter your git commit message:"; \
	read msg; \
	git add src/ Makefile *.md; \
	git commit -m "$$msg"; \
	git push
```
