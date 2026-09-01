.PHONY: check common-conformance-gate f110-local-gate launcher-consumer-readiness test test-offline

UV ?= uv

# `check` is the convention across the 0.2.1 repositories; f110-local-gate is
# this repository's intended entry point, so `check` is an alias for it rather
# than a second, divergent gate.
.DEFAULT_GOAL := check

check: f110-local-gate

test:
	$(UV) run --locked python validate_contract.py --self-test

test-offline:
	$(UV) run --locked --offline python validate_contract.py --self-test

launcher-consumer-readiness:
	$(UV) run --locked --offline python -m kilix_desktop_contract.readiness --self-test

f110-local-gate: test-offline launcher-consumer-readiness

common-conformance-gate:
	@test -n "$(COMMANDS)" -a -n "$(KILIX_HOME)" -a -n "$(CONTRACT_COMMAND)" -a -n "$(STATE_LIBRARY)" -a -n "$(LAND_ASSETS)"
	$(UV) run --locked --offline kilix-desktop-contract conformance-matrix \
		--commands "$(COMMANDS)" \
		--kilix-home "$(KILIX_HOME)" \
		--contract-command "$(CONTRACT_COMMAND)" \
		--state-library "$(STATE_LIBRARY)" \
		--land-assets "$(LAND_ASSETS)"
