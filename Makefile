.DEFAULT_GOAL=check
.PHONY: symlink
symlink:
	ln -s "$(PWD)" "$(shell v doctor | grep VMODULES | sed 's/^.*value: //')"
