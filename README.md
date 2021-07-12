## preview-bot

![](https://github.com/allamand/preview-bot/raw/master/assets/robot.png)

The preview-bot application polls for GitHub notifications like @preview-bot mentions and performs actions.

For example, whitelisted GitHub users (namely, @allamand) can mention @preview-bot with a command "preview this" in a pull request to provision a preview environment.

Built with GitHub APIs, AWS Elastic Container Service, AWS Fargate, AWS CodeBuild, Amazon ECR, and AWS CloudFormation

### How does preview-bot work?

The preview-bot container constantly polls the [GitHub Notifications APIs](https://developer.github.com/v3/activity/notifications/) for any mentions of the @preview-bot username on GitHub pull requests. If the mentioner is whitelisted, preview-bot attempts to set up a preview environment in the same AWS account. The preview-bot provisioning behavior is hard-coded to look for a buildspec.yml file in order to complete a CodeBuild build, and then to look for a template.yml file in the build artifact to use as a CloudFormation template for the preview environment.

### Set up your own bot

0. Configure the environment where to deploy the Bot

```bash
BOT_NAME=<your-github-bot-name>
AWS_REGION=<your-region>
CLUSTER_NAME=<cluster_name>
WHITELIST_USER=<user-to-whitelist>
#Tag name of the VPC where to deploy or "default" to deploy in default VPC
VPC_TAG_NAME=JenkinsKanikoStack/jenkins-vpc
```

Create an ssm parameter with the value of your domain certificat

This is the certificat which will be use to expose our services from the bot example:

```bash
aws ssm put-parameter --region $AWS_REGION --tags Key=project,Value=trivia --name CertificateArn-ecs.demo3.allamand.com --type String --value arn:aws:acm:...
```

1. Create a GitHub user for your bot, like @preview-bot.

2. Update the user's [notification settings](https://github.com/settings/notifications) to select:

- **Automatically watch repositories**
- Participating **Web and Mobile**
- Watching **Web and Mobile**

3. Create a [personal access token](https://github.com/settings/tokens) for the bot user with the following scopes:

- `repo` (Full control of private repositories)
- `notifications` (Access notifications)

Store the token in AWS Systems Manager Parameter Store:

```bash
aws ssm put-parameter --region $AWS_REGION --name ${BOT_NAME}-github-token --type SecureString --value <YOUR_BOT_GITHUB_TOKEN>
```

4. Invite the bot as a collaborator of your GitHub Repository.

5. Deploy the Bot

You can deploy in default VPC or in the VPC of your choice by configuring the **VPC_TAG_NAME** env var, cf `./scripts/0.pre-requisite.sh` file

Once the file is configured, you can source it

```bash
source ./scripts/0.pre-requisite.sh
```

Provision the stack in CloudFormation with the bot disabled:

```bash
make deploy-without-activation
```

> TODO: change permissions on cloudformation stack to least privilege

Then, build and push the bot docker image to ECR.

```bash
make build
```

Once the bot is build and pushed, you can enable it.

```bash
make deploy-activate
```

### Test Locally

```
GITHUB_TOKEN=`aws ssm get-parameter --name ${BOT_NAME}-github-token --with-decryption --query 'Parameter.Value' --output text`
docker run --rm -v $HOME/.aws:/root/.aws:ro -e AWS_REGION=$AWS_REGION -e githubToken=$GITHUB_TOKEN $BOT_NAME
```

# Crédit

This works if derived from awsome work from Clare Liguory

https://github.com/clareliguori/clare-bot
