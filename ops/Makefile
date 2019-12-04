init:
	aws-vault exec aws-admin -- terraform init

validate:
	aws-vault exec aws-admin -- terraform validate

plan: validate
	aws-vault exec aws-admin -- terraform plan

apply: validate
	aws-vault exec aws-admin -- terraform apply
