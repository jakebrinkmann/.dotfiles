CFN_STACK_NAME= StackName
#CFN_ROLE = arn:aws:iam::1234:role/Roles-StackNameCloudformation-ABC123
CFN_S3= stack-name-dev-cfn

.PHONY: validate ## Make sure SAM template is valid
validate:
	sam validate --template template.yaml

.PHONY: build ## Process AWS SAM template file
build:
	sam build --template template.yaml

.PHONY: package ## Upload code/dependencies to Amazon S3 as .zip
package:
	sam package \
		--output-template-file packaged.yaml \
		--s3-bucket $(CFN_S3)\
		--force-upload

.PHONY: deploy
deploy:
	sam deploy \
		--template-file packaged.yaml \
		--capabilities CAPABILITY_NAMED_IAM \
		--stack-name $(CFN_STACK_NAME)\
		--tags StackName=$(CFN_STACK_NAME)\
		--no-confirm-changeset #--role-arn $(CFN_ROLE)

.PHONY: sam
sam: validate build package deploy
