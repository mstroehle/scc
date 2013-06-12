#
# Makefile for R-package SCC
#
# This Makefile aims for supporting the developer of the 
# R package scc in testing and building the package
#
# Author: Jakob Bossek <jakob.bossek@tu-dortmund.de>
#

# Configuration and shortcuts

# Combination of --no-save --no-restore and so on
R := R --vanilla --quiet
RSCRIPT := RScript --vanilla --quiet

# shortcut for deletion of file or directory (recursively and forced)
DELETE := rm -fr

.SILENT:
.PHONEY: clean test check build install package data usage help

usage:
	echo "Available targets:"
	echo "install   - install the package and write output to install.log logfile"
	echo "package   - build source tarball"
	echo "test      - run test suite"
	echo "check     - run R CMD check on the package"

install: clean pkg
	echo "Be patient young padawan! Installing package..."
	${R} CMD INSTALL pkg > install.log 2>&1

package: pkg
	echo "Be patient young padawan! Building package tarball..."
	${R} CMD build pkg/ > package.log 2>&1

check: clean pkg
	echo "Running R CMD check..."
	${R} CMD check pkg && ${DELETE} pkg.Rcheck

pkg: clean
	echo "Roxigenizing package..."
	${RSCRIPT} ./tools/roxygenize > roxygen.log 2>&1
	echo "Setting 'Version'in DESCRIPTION"
	${RSCRIPT} ./tools/set-version 1 0

test: install
	${RSCRIPT} ./tools/run-tests

clean:
	echo "Cleaning up..."
	${DELETE} build.log install.log roxygen.log package.log
	${DELETE} skel/src/*.o skel/src/*.so
	${DELETE} pkg
	${DELETE} pkg.Rcheck
	${DELETE} .RData .Rhistory