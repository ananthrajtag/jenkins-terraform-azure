pipeline {
  agent {
    docker {
      image 'hashicorp/terraform:light'
    }
  }
  environment {
      ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
      ARM_CLIENT_ID = credentials('client-id-jenkins-sp')
      ARM_CLIENT_SECRET = credentials('client-secret-jenkins-sp')
      ARM_TENANT_ID  = credentials('azure-tenant-id')
      storage_key = credentials('tfstate-storage-key')
  }
  stages {
  stage('Terraform init') {
    steps {
          sh 'id'
          sh 'rm -rf jenkins-terraform-azure'
          sh 'git clone https://github.com/gbpeva3/jenkins-terraform-azure.git'
          sh '''
             cd jenkins-terraform-azure
             terraform init -input=false -backend-config="resource_group_name=tfstate" \
                                         -backend-config="storage_account_name=tfstate90876" \
                                         -backend-config="container_name=jenkinstf" \
                                         -backend-config="key=${storage_key}" \
                                         -backend-config="access_key=${storage_key}"
          '''
      }
    }
  }
}
