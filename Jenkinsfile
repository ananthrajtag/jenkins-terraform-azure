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
  stage('Terraform test') {
    steps {
          echo 'Hello world'
          sh 'terraform --version'
      }
    }
  }
}
