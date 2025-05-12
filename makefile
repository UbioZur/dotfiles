## ~  UbioZur - https://github.com/UbioZur  ~ ##

#
# Makefile to install / update my dotfiles.
#

# List of directories to be used for an headless target (i.e. server)
DIRS_HEADLESS := bash fastfetch fonts wget

# List of files that are not neccessary to copy
EXCLUDE_FILES := *.md

# Repository specific directories which are not dotfiles
EXCLUDE_DIRS :=

# User home directory
HOME_DIR := $(shell echo ~)/

# Determine the current directory of the Makefile
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# List of all directories in the Makefile's directory (excluding hidden directories/files)
DIRS_ALL := $(filter-out $(wildcard $(MAKEFILE_DIR).*), $(wildcard $(MAKEFILE_DIR)*/))

# Directories to copy for all targets
COPY_DIRS := $(filter-out $(EXCLUDE_DIRS), $(DIRS_ALL))

# Directories to copy for headless target (excluding hidden/excluded directories)
COPY_DIRS_HEADLESS := $(foreach dir,$(DIRS_HEADLESS),$(filter $(MAKEFILE_DIR)$(dir)%/,$(COPY_DIRS)))

# Define the lock file used for the update target
LOCK_FILE := $(MAKEFILE_DIR)directories.lock

# name for the Cron file job
CRON_NAME := dotfiles_update

# Function to extract basename from path (handles trailing slash)
get_basename = $(notdir $(patsubst %/,%,$(1)))

# Everything is PHONY
.PHONY: all clean cron debug headless help update

# Install every dotfiles
all:
	@echo -e "\e[1mTarget: all\e[0m"
	@for dir in $(COPY_DIRS) ; do \
		echo "Copying dotfiles from $$dir" ; \
		rsync -avrq --exclude=$(EXCLUDE_FILES) $$dir/ $(HOME_DIR) ; \
		touch $(LOCK_FILE) ; \
		grep -qxF $$dir $(LOCK_FILE) || echo $$dir >> $(LOCK_FILE) ; \
	done

# Cleanup an install
clean:
	@echo -e "\e[1mTarget: clean\e[0m"
	@echo "Removing lock file"
	@rm -f $(LOCK_FILE)
	@echo "Removing crontab entry"
	@crontab -l | grep -v "$(CRON_NAME)" | crontab -

# Create a cron job
cron:
	@echo -e "\e[1mTarget: cron\e[0m"
	@echo "Adding cron job to run daily at 12:00."
	@(crontab -l | grep -v "$(CRON_NAME)" ; echo "0 12 * * * cd $(MAKEFILE_DIR) && git pull && make update # $(CRON_NAME) Update the dotfiles") | crontab -

#Print debug information
debug:
	@echo -e "\e[1mMakefile Directory | MAKEFILE_DIR :\e[0m"
	@echo "$(MAKEFILE_DIR)"
	@echo ""
	@echo -e "\e[1mAll target Directories | COPY_DIRS :\e[0m"
	@echo "$(call get_basename,$(COPY_DIRS))" | tr ' ' '\n'
	@echo ""
	@echo -e "\e[1mHeadless target Directories | COPY_DIRS_HEADLESS :\e[0m"
	@echo "$(call get_basename,$(COPY_DIRS_HEADLESS))" | tr ' ' '\n'
	@echo ""
	@echo -e "\e[1mLock File | LOCK_FILE :\e[0m"
ifeq ("$(wildcard $(LOCK_FILE))","")
	@echo "Lock File $(LOCK_FILE) does not exist."
else
	@cat $(LOCK_FILE)
endif
	@echo ""
	@echo -e "\e[1mCron Entry | CRON_NAME :\e[0m"
	@echo "$(shell crontab -l | grep "$(CRON_NAME)")"

# Install headless dotfiles
headless:
	@echo -e "\e[1mTarget: headless\e[0m"
	@for dir in $(COPY_DIRS_HEADLESS) ; do \
		echo "Copying dotfiles from $$dir" ; \
		rsync -avrq --exclude=$(EXCLUDE_FILES) $$dir/ $(HOME_DIR) ; \
		touch $(LOCK_FILE) ; \
		grep -qxF $$dir $(LOCK_FILE) || echo $$dir >> $(LOCK_FILE) ; \
	done

# Print help usage information
help:
	@echo -e "\e[1mDotfiles Makefile\e[0m"
	@echo ""
	@echo "Usage: make [OPTIONS]"
	@echo ""
	@echo "Options to install dotfiles"
	@echo "  all:       (DEFAULT) Install/Copy all the dotfiles."
	@echo "  headless:  Install/copy dotfiles for headless systems"
	@echo "  cron:      Add a cronjob dayly at 12:00 to update the git and dotfiles."
	@echo ""
	@echo "Standalone options to manage installed dotfiles"
	@echo "  update:    Update the already installed dotfiles."
	@echo "  clean:     Remove the cronjob and directories.lock file."
	@echo ""
	@echo "Extra Options to help development"
	@echo "  debug:     Print some debug information."

# Update installed dotfiles
update:
	@echo -e "\e[1mTarget: update\e[0m"
ifeq ("$(wildcard $(LOCK_FILE))","")
	# File does NOT exist
	$(error File $(LOCK_FILE) does not exist with the list of previously installed dotfiles.)
endif
	$(info Updating the dotfiles based on the file $(LOCK_FILE))
	@while IFS= read -r line; do \
		echo "Updating $$line"; \
		rsync -avrq --exclude=$(EXCLUDE_FILES) "$$line"/ $(HOME_DIR); \
	done < $(LOCK_FILE)
