# Hail release

## gVCF manifest

Initially 10,714 samples were registered for the project Singapore National Precision Medicine Phase I.
 A subset of 10,323 samples has been successfully sequenced and processed through GATK4 pipeline to be included in SG10K_Health dataset.
 Subsequenlty, SG10K_Health have been re-analysed using DRAGEN pipeline.

Following instructions from [c-BIG/Hail-on-AWS](https://github.com/c-BIG/Hail-on-AWS) [to be updated]

## Create an EC2

- Log into AWS web console / `EC2` service
- Click on Launch instance
- Name: `HailOnAWS-AMICreation`
- AMI: `Amazon Linux 2023 AMI`
- Architecture: `64-bit (Arm)`
- Instance type: `t4g.xlarge` (4CPU 16Gb)
- Key pair: `[KEY]`
- VPC: `[VPC]`
- Subnet: `[any subnet available]`
- Auto-assign public IP: `Enable`
- Firewall: `Select existing security group`
- Common security groups: `[SecurityGroup]`
- Configure Storage: 1x `50` Gib `gp3`
- Click on `Launch instance`

After instance creation note the instance id

## Install Hail & dependencies

- Log into AWS web console / `EC2` service / `Instances` section / `Instances` sub-section
- Click on the instance created previously `[instance id]`
- Copy the Public IPv4 DNS: `[IP]`
- SSH to the EC2

  ```sh
  MASTER=[IP]; PEM=[PEM KEY]; ssh -i $PEM ec2-user@$MASTER
  ```

- Install dependencies. Copy/Paste instructions in `hail_install.sh`
- Disconnect from the EC2

## Create an AMI

- Log into AWS web console / `EC2` service / `Instances` section / `Instances` sub-section
- Click on the instance created previously `[instance id]`
- Click on `Actions` / `Image and templates` / `Create image`
- Image name: `HailonEMR-0.2.134`
- Image description: `Java 11 & Hail v0.2.134`
- Click on `Create image`

After AMI creation note the AMI id

## Launch an EMR

- Use the cloudformation template available at [TBD]
- Create a parameter file named `gnomad-params.json` used to preset the parameters of the cloudFormation template.

  ```json
  [
    {"ParameterKey": "OwnerTag", "ParameterValue": ""},
    {"ParameterKey": "KeyName", "ParameterValue": ""},
    {"ParameterKey": "ProjectTag", "ParameterValue": "SG10K-Reanalysis"},
    {"ParameterKey": "EnvironmentTag", "ParameterValue": "prod"},
    {"ParameterKey": "DemandCPUCount", "ParameterValue": "10"},
    {"ParameterKey": "SpotCPUCount", "ParameterValue": "0"},
    {"ParameterKey": "DiskSizeGB", "ParameterValue": "65"},
    {"ParameterKey": "NotebooksAccount", "ParameterValue": "c-BIG"},
    {"ParameterKey": "NotebooksRepo", "ParameterValue": "gnomad-singapore"},
    {"ParameterKey": "CFNBucket", "ParameterValue": ""},
    {"ParameterKey": "EMRLogBucket", "ParameterValue": ""},
    {"ParameterKey": "EMRLogEncryptionKey", "ParameterValue": ""},
    {"ParameterKey": "HailAMI", "ParameterValue": ""},
    {"ParameterKey": "NotebooksCreds", "ParameterValue": ""},
    {"ParameterKey": "Subnet", "ParameterValue": ""},
    {"ParameterKey": "SecurityGroup", "ParameterValue": ""},
    {"ParameterKey": "NameTag", "ParameterValue": "emr-node"}
  ]
  ```

- Create a Cluster:

  ```sh
  aws cloudformation create-stack \
  --stack-name emr-hail134-gnomad \
  --template-url https://s3.amazonaws.com/.../stack-hail.yml \
  --parameters file://.local/gnomad_params.json
  ```

## Connect to the cluster

- Log into `AWS web console` / `CloudFormation` service
- Click on the stack `emr-hail134-gnomad`
- Click on `Outputs` tab
- Copy the EMRMasterDNS: `[IP]`
- SSH to the master node:

  ```sh
  MASTER=[IP]; PEM=[KEY]; ssh -i $PEM -L 9443:$MASTER:9443 -L 18080:$MASTER:18080 hadoop@$MASTER
  ```

- Check the steps are completed: In a terminal

  ```sh
  tail /tmp/cloudcreation_log.out
  ```

  Expected output: `### END CONFIG_JUPYTER.SH ###`
- Visit JupyterLab at <https://localhost:9443/user/jovyan/lab>
- Login to jupyter:
  - Username: jovyan
  - Password: jupyter
- Click on `Launch Server`

## Analysis
