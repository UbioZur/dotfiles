## ~  UbioZur - https://github.com/UbioZur  ~ ##


#### Makefile to copy and "install" / "update" my dotfiles


#### Directories to use for a headless target

DIRS_HEADLESS := bash fastfetch fonts wget


#### Files to Exclude in the install

EXCLUDE_FILES := *.md


#### Directories to excludes in the copy for all (non . diretories used for the repo)

EXCLUDE_DIRS :=


#### Used Variables

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
LOCK_FILE := $(MAKEFILE_DIR)directory.lock


#### Usefull functions

# Function to extract basename from path (handles trailing slash)

get_basename = $(notdir $(patsubst %/,%,$(1)))

#### Copy ALL dotfiles as a default target

.PHONY: all
all: $(COPY_DIRS)


#### Dynamic targets building, each folder can have it's own target

.PHONY: $(COPY_DIRS)
$(COPY_DIRS): %:
	@echo "Copying dotfiles from $* ..."
	@rsync -avr --exclude=$(EXCLUDE_FILES) $*/ $(HOME_DIR)
	@grep -qxF $* $(LOCK_FILE) || echo $* >> $(LOCK_FILE)


#### Copy dotfiles only usefull for headless system

.PHONY: headless
headless: $(COPY_DIRS_HEADLESS)


#### Clean up the lock file

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -f $(LOCK_FILE)


#### Update dotfiles based on the lockfile

.PHONY: update
update:
	@echo "Updating dotfiles based on $(LOCK_FILE)..."
	@while IFS= read -r line; do \
		@rsync -avr --exclude=$(EXCLUDE_FILES) $*/ $(HOME_DIR); \
	done < $(LOCK_FILE)


#### To use for debugging

.PHONY: debug
debug:
	@echo "MAKEFILE_DIR $(MAKEFILE_DIR)"
	@echo "---"
	@echo "DIRS_ALL $(DIRS_ALL)"
	@echo "COPY_DIRS $(COPY_DIRS)"
	@echo "---"
	@echo "DIRS_HEADLESS $(DIRS_HEADLESS)"
	@echo "COPY_DIRS_HEADLESS $(COPY_DIRS_HEADLESS)"
	@echo "---"
	@echo "$(foreach dir,$(COPY_DIRS_HEADLESS),$(call get_basename,$(dir)))"
