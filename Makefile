systems := "wendy"
wendy_ip := "91.98.123.111"
test:
	for system in $(systems) ; do \
		nixos-anywhere --flake .#$$system --vm-test ; \
	done

wendy:
	nixos-anywhere --flake .#wendy --target-host cxefa@91.98.123.111 --build-on-remote -p 5432 -i ~/.ssh/xyz

.PHONY: test wendy
