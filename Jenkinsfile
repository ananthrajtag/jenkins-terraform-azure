pipeline {
  agent any
  
  environment {
      ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
      ARM_CLIENT_ID = credentials('client-id-jenkins-sp')
      ARM_CLIENT_SECRET = credentials('client-secret-jenkins-sp')
      ARM_TENANT_ID  = credentials('azure-tenant-id')
      terraform = 'docker run -it hashicorp/terraform:light'
  }
  stages {
  stage('Terraform test') {
    steps {
          sh '''
            echo 'Hello world'
            ${terraform}
          '''
      }
    }
  }
}
