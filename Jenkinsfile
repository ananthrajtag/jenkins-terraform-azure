pipeline {
  agent {
      node {
          label 'master'
      }
  }

  environment {
      subscription_id = credentials('phils-subscription')
      tenant_id = credentials('phils_tenant')
      client_id = credentials('phils-client')
      client_secret = credentials('phils-secret')
      storage_key = credentials('phils-storage-key')
  }
  stages {
    stage('Terraform init') {
      steps {
            sh '''
               docker run -v /var/lib/jenkins/workspace/TerraformAzure:/var/lib/jenkins/workspace/TerraformAzure:rw,z \
                          -w /app \
                          -v /var/lib/jenkins/workspace/TerraformAzure:/app \
                          -e ARM_SUBSCRIPTION_ID="${subscription_id}" \
                          -e ARM_TENANT_ID="${tenant_id}" \
                          -e ARM_CLIENT_ID="${client_id}" \
                          -e ARM_CLIENT_SECRET="${client_secret}" \
                          hashicorp/terraform:light \
                          init -input=false -backend-config="resource_group_name=tfstate" \
                                            -backend-config="storage_account_name=philstate" \
                                            -backend-config="container_name=jenkinstf" \
                                            -backend-config="key=${storage_key}" \
                                            -backend-config="access_key=${storage_key}"
            '''
      }
    }
    stage('Terraform plan') {
      steps {
            sh '''
               docker run -v /var/lib/jenkins/workspace/TerraformAzure:/var/lib/jenkins/workspace/TerraformAzure:rw,z \
                       -w /app \
                       -v /var/lib/jenkins/workspace/TerraformAzure:/app \
                       -e ARM_SUBSCRIPTION_ID="${subscription_id}" \
                       -e ARM_TENANT_ID="${tenant_id}" \
                       -e ARM_CLIENT_ID="${client_id}" \
                       -e ARM_CLIENT_SECRET="${client_secret}" \
                       hashicorp/terraform:light \
               plan -out=tfplan -input=false
            '''
            script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
            }
      }
    }
    stage('Terraform apply') {
      steps {
            sh  '''
                docker run -v /var/lib/jenkins/workspace/TerraformAzure:/var/lib/jenkins/workspace/TerraformAzure:rw,z \
                       -w /app \
                       -v /var/lib/jenkins/workspace/TerraformAzure:/app \
                       -e ARM_SUBSCRIPTION_ID="${subscription_id}" \
                       -e ARM_TENANT_ID="${tenant_id}" \
                       -e ARM_CLIENT_ID="${client_id}" \
                       -e ARM_CLIENT_SECRET="${client_secret}" \
                       hashicorp/terraform:light \
                apply -lock=false -input=false tfplan
            '''
      }
    }
  }
}
