pipeline {
  agent any
  
  environment {
      ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
      ARM_CLIENT_ID = credentials('client-id-jenkins-sp')
      ARM_CLIENT_SECRET = credentials('client-secret-jenkins-sp')
      ARM_TENANT_ID  = credentials('azure-tenant-id')
      storage_key = credentials('tfstate-storage-key')
      terraform = 'docker run -v /var/lib/jenkins/workspace/TerraformAzure:/var/lib/jenkins/workspace/TerraformAzure:rw,z hashicorp/terraform:light'
  }
  stages {
    stage('Terraform init') {
      steps {
            sh '''
               ${terraform} init -input=false -backend-config="resource_group_name=tfstate" \
                                              -backend-config="storage_account_name=tfstate90876" \
                                              -backend-config="container_name=jenkinstf" \
                                              -backend-config="key=${storage_key}" \
                                              -backend-config="access_key=${storage_key}"
            '''
      }
    }
    stage('Terraform plan') {
      steps {
            sh '''
               ${terraform} plan -out=tfplan -input=false
            '''
            script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
            }
      }
    }
  }
}
