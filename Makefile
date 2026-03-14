systems := wendy
wendy_ip := 91.98.123.111
port := 5432
keyfile := ~/.ssh/xyz
test:
	for system in $(systems) ; do \
		nixos-anywhere --show-trace --flake .#$$system --vm-test ; \
	done

$(foreach system,$(systems),install-$(system)):
	nixos-anywhere --show-trace --flake .#$(subst install-,,$@) --target-host cxefa@$($(subst install-,,$@)_ip) --build-on remote -p $(port) -i $(keyfile)

$(foreach system,$(systems),rebuild-$(system)):
	NIX_SSHOPTS="-i $(keyfile) -p $(port)" nixos-rebuild --show-trace --flake .#$(subst rebuild-,,$@) --target-host cxefa@$($(subst rebuild-,,$@)_ip) --build-host cxefa@$($(subst rebuild-,,$@)_ip) switch

all: $(foreach system,$(systems),rebuild-$(system))

.PHONY: test
