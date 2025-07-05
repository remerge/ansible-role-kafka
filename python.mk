.PHONY: python-install
python-install: ## install Python packages from pyproject.toml
	uv sync --frozen
install:: python-install

.PHONY: python-update
python-update:: ## update Python packages from pyproject.toml
	uv sync --upgrade
update:: python-update

.PHONY: python-clean
python-clean: ## remove current Python virtualenv
	rm -rf .venv
	rm -rf .ruff_cache
clean:: python-clean

.PHONY: python-test
python-test:: ## run Python tests
	uv run pytest
test:: python-test
