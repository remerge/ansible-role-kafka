.PHONY: python-install
python-install: ## install Python packages from pyproject.toml
	poetry install --no-interaction --no-root
install:: python-install

.PHONY: python-update
python-update:: ## update Python packages from pyproject.toml
	poetry update --no-interaction
update:: python-update

.PHONY: python-clean
python-clean: ## remove current Python virtualenv
	poetry env remove python || :
	rm -rf .venv
clean:: python-clean
