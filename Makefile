DEPS = ./deps
PROJECT=lfe-rackspace
LIB=lferax
EBIN=ebin
SRC=src
CONFIG_DIR = ~/.rax
LFE_DIR = $(DEPS)/lfe
LFE_EBIN = $(LFE_DIR)/ebin
LFE = $(LFE_DIR)/bin/lfe
LFEC = $(LFE_DIR)/bin/lfec
LFE_UTILS_DIR = $(DEPS)/lfe-utils
LFEUNIT_DIR = $(DEPS)/lfeunit
JIFFY_DIR = $(DEPS)/jiffy
# Note that ERL_LIBS is for running this project in development and that
# ERL_LIB is for installation.
ERL_LIBS = $(LFE_DIR):$(LFE_UTILS_DIR):$(LFEUNIT_DIR):$(JIFFY_DIR):./
SOURCE_DIR = ./src
OUT_DIR = ./ebin
TEST_DIR = ./test
TEST_OUT_DIR = ./.eunit
FINISH=-run init stop -noshell

get-version:
	@erl -eval 'io:format("~p~n", [ \
		proplists:get_value(vsn,element(3,element(2,hd(element(3, \
		erl_eval:exprs(element(2, erl_parse:parse_exprs(element(2, \
		erl_scan:string("Data = " ++ binary_to_list(element(2, \
		file:read_file("src/$(LIB).app.src"))))))), []))))))])' \
		$(FINISH)

# Note that this make target expects to be used like so:
#	$ ERL_LIB=some/path make get-install-dir
#
# Which would give the following result:
#	some/path/lfe-rackspace-1.0.0
#
get-install-dir:
	@echo $(ERL_LIB)/$(PROJECT)-$(shell make get-version)

get-deps:
	rebar get-deps
	for DIR in $(wildcard $(DEPS)/*); do cd $$DIR; git pull; cd - ; done
	mkdir -p $(CONFIG_DIR)

clean-ebin:
	rm -f $(OUT_DIR)/*.beam

clean-eunit:
	rm -rf $(TEST_OUT_DIR)

compile: get-deps clean-ebin
	rebar compile
	cd $(JIFFY_DIR) && rebar compile

compile-tests: clean-eunit
	mkdir -p $(TEST_OUT_DIR)
	ERL_LIBS=$(ERL_LIBS) $(LFEC) -o $(TEST_OUT_DIR) $(TEST_DIR)/*_tests.lfe

shell: compile
	clear
	ERL_LIBS=$(ERL_LIBS) $(LFE) -pa $(TEST_OUT_DIR)

clean: clean-ebin clean-eunit
	rebar clean

check: compile compile-tests
	@clear;
	@rebar eunit verbose=1 skip_deps=true

push-all:
	git push --all
	git push upstream --all
	git push --tags
	git push upstream --tags

# Note that this make target expects to be used like so:
#	$ ERL_LIB=some/path make install
#
install: INSTALLDIR=$(shell make get-install-dir)
install: compile
	if [ "$$ERL_LIB" != "" ]; \
	then mkdir -p $(INSTALLDIR)/$(EBIN); \
		mkdir -p $(INSTALLDIR)/$(SRC); \
		cp -pPR $(EBIN) $(INSTALLDIR); \
		cp -pPR $(SRC) $(INSTALLDIR); \
	else \
		echo "ERROR: No 'ERL_LIB' value is set in the env." \
		&& exit 1; \
	fi
