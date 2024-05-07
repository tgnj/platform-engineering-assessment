.PHONY: setup
setup:
	@echo "Setting up the project ..."
	@echo "Creating docker environment ..."
	@docker-compose up db kafka -d
	@echo "Preparing database / kafka ..."
	@rails db:migrate
	@bundle exec karafka-web migrate

tear:
	@echo "Tearing down the project ..."
	@docker-compose down -v
