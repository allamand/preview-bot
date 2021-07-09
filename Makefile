

check:
	./scripts/1.check-prerequisites.sh

deploy-without-activation:check
	./scripts/2.deploy-without-activation.sh

build:check
	./scripts/3.build.sh


deploy-activate:check
	./scripts/4.deploy-activate.sh


local:
	GITHUB_TOKEN=$(shell aws ssm get-parameter --name $$BOT_NAME-github-token --with-decryption --query 'Parameter.Value' --output text) && \
	docker run --rm -v $$HOME/.aws:/root/.aws:ro -e AWS_REGION=$$AWS_REGION -e githubToken=$$GITHUB_TOKEN $$BOT_NAME