# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# Set CONFIG to "LOCAL" by default. Other valid values: "TEST" or "MAIN".
#CONFIG ?= LOCAL
CONFIG ?= TEST

LN_FLAGS := $(if $(findstring Darwin,$(shell uname)),-shF,-sfT)

# See README.md for more documentation.
NODE_MODULES := ./node_modules

# The reason for this weird setup is that the IntelliJ solidity plugin will not resolve imports
# if they're not in `lib` and do not have a `src` directory (the `remappings.txt` file is ignored).
setup:
	if [ ! -f .env ]; then cp .env.example .env; fi
	rm -rf lib
	ln $(LN_FLAGS) ../$(NODE_MODULES)/forge-std lib/forge-std
	ln $(LN_FLAGS) ../../$(NODE_MODULES)/@openzeppelin/contracts lib/openzeppelin/src
	ln $(LN_FLAGS) ../../$(NODE_MODULES)/@openzeppelin/contracts-upgradeable lib/oz-upgradeable/src
.PHONY: setup

####################################################################################################
# Build

build:
	forge build
.PHONY: build

watch:
	forge test --watch src/
.PHONY: watch

clean:
	forge clean
	rm -rf node_modules/.tmp
.PHONY: clean

nuke: clean
	rm -rf lib
.PHONY: nuke

####################################################################################################
# Testing

test:
	forge test -vv
.PHONY: test

testv:
	forge test -vvvv
.PHONY: testv

test-fork:
	forge test --gas-report --fork-url $(RPC_$(CONFIG))
.PHONY: test-fork

demo:
	tsx ./scripts/demo.ts;
.PHONY: demo

####################################################################################################
# Code Quality

format-check:
	forge fmt --check src
.PHONY: format-check

lint:
	solhint --config ./.solhint.json "src/**/*.sol";
.PHONY: lint

format:
	biome check ./ --write;
	forge fmt src
.PHONY: format

####################################################################################################
# Devnet

# The 1337 chain id matches "localhost" in Wagmi & "Localhost 8545" in MetaMask.
# (Unfortunately some tools will mistakenly report this as not having the Shangai fork activated.)
anvil:
	anvil --chain-id 1337 --block-time 2
.PHONY: anvil

####################################################################################################
# Deployment

VERIFY_FLAG := $(if $(findstring true,$(VERIFY_$(CONFIG))),--verify,)
VIA_IR_FLAG := $(if $(findstring DeployAA,$(DEPLOY_SCRIPT)),--via-ir,)
OPTIMIZER_RUNS_FLAG := $(if $(findstring DeployAA,$(DEPLOY_SCRIPT)),--optimizer-runs 200,)

# Deploys contracts locally, to testnet or mainnet depending on the $CONFIG value.
# You can also specify MODE=dry to not submit the tx, or MODE=resume to resume the last deployment.
deploy:
	$(call run-deploy-script,src/deploy/$(DEPLOY_SCRIPT))
.PHONY: deploy

# Defines run-deploy-script to use environment variable keys or Foundry accounts depending on the
# value of USE_FOUNDRY_ACCOUNT.
define run-deploy-script
	$(eval __USE_ACC := $(findstring true,$(USE_FOUNDRY_ACCOUNT)))
	$(eval __DEPLOY_FUNC := $(if $(__USE_ACC),run-deploy-script-account,run-deploy-script-key))
	$(call $(__DEPLOY_FUNC),$(1))
endef

# Deploys using a private key supplied in an environment variable (dependent on the $CONFIG value).
define run-deploy-script-key
    @# Command intentionally output.
	forge script $(1) \
		--fork-url $(RPC_$(CONFIG)) \
		--private-key $(PRIVATE_KEY_$(CONFIG)) \
		$(VIA_IR_FLAG) \
		$(OPTIMIZER_RUNS_FLAG) \
		$(BROADCAST_FLAG) \
		$(VERIFY_FLAG)
endef

# Deploys using a private key supplied by a Foundry account. The account name and password file
# are supplied in environment variables (dependent on the $CONFIG value).
define run-deploy-script-account
	@$(eval DEPLOY_SENDER := `cast wallet address \
		--account $(ACCOUNT_$(CONFIG)) \
		--password-file $(PASSFILE_$(CONFIG))`)
	@# Command intentionally output.
	forge script $(1) \
		--fork-url $(RPC_$(CONFIG)) \
		--account $(ACCOUNT_$(CONFIG)) \
		--password-file $(PASSFILE_$(CONFIG)) \
		--sender $(DEPLOY_SENDER) \
		$(VIA_IR_FLAG) \
		$(OPTIMIZER_RUNS_FLAG) \
		$(BROADCAST_FLAG) \
		$(VERIFY_FLAG)
endef##########################################################################
