rhel9_base:
	packer init -var-file variables/rhel9_base.pkrvars.hcl builds/linux/rhel/9
	packer build -var-file variables/rhel9_base.pkrvars.hcl -var-file variables/common.pkrvars.hcl builds/linux/rhel/9

aap_demo:
	@set -a && source .env.local && set +a && \
	packer init -var-file variables/rhel9_aap_demo.pkrvars.hcl builds/linux/rhel/9
	packer build -var-file variables/rhel9_aap_demo.pkrvars.hcl -var-file variables/common.pkrvars.hcl builds/linux/rhel/9

rhel9_aap_job:
	packer init -var-file variables/rhel9_aap_job.pkrvars.hcl builds/linux/rhel/9
	packer build -var-file variables/rhel9_aap_job.pkrvars.hcl -var-file variables/common.pkrvars.hcl builds/linux/rhel/9

rhel9_aap_workflow:
	packer init -var-file variables/rhel9_aap_workflow.pkrvars.hcl builds/linux/rhel/9
	packer build -var-file variables/rhel9_aap_workflow.pkrvars.hcl -var-file variables/common.pkrvars.hcl builds/linux/rhel/9