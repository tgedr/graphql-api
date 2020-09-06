
graphql-api
=========
automation to create a graphql api on `aws`

## requirements
  - terraform
  - svn

## how to
  - fork/clone this repository;
  - edit variables in `CUSTOMISABLE SECTION` in `variables.inc`:
    - APPLICATION: choose a name for the application;
    - AWS_REGION: the aws region you want to use along with your account;
    - ENVIRONMENT: define an environment that wil become the deployment stage;
    - FUNCTION_*: provide info about the github release of the function 
    that is going to be responsible for handling the related lambda calls;
    - Note: you can still customise variables FUNCTION_RUNTIME, FUNCTION_TIMEOUT
    and FUNCTION_MEMORY, as defaults are defined in `vars.tf`
  - create a `secrets.inc` in the base folder and from there export your `AWS` account credentials, 
  you must have a sort-of admin account:
  ![secrets01][secrets01]
  - download the latest `bashutils` include file:
  ![bashutils01][bashutils01]
  - create remote `terraform` state: 
  ![stateon01][stateon01]
  ![stateon02][stateon02]
  - deploy api:
  ![deploy01][deploy01]
  ![deploy02][deploy02]
  - test the api, use context path `graphql` :
  ![post01][post01]
  
[stateon01]: assets/stateon01.png "stateon01"
[stateon02]: assets/stateon02.png "stateon02"
[deploy01]: assets/deploy01.png "deploy01"
[deploy02]: assets/deploy02.png "deploy02"
[post01]: assets/post01.png "post01"
[secrets01]: assets/secrets01.png "secrets01"
[bashutils01]: assets/bashutils01.png "bashutils01"