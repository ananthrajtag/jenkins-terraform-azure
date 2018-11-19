pipeline {
  agent {
      node {
          label 'master'
      }
  }

  environment {
      subscription_id = credentials('phils-subscription')
      storage_key = credentials('tfstate-storage-key')
      terraform = 'docker run -v /var/lib/jenkins/workspace/TerraformAzure:/var/lib/jenkins/workspace/TerraformAzure:rw,z -w /app -v /var/lib/jenkins/workspace/TerraformAzure:/app -e ARM_SUBSCRIPTION_ID='credentials('phils-subscription')' -e ARM_TENANT_ID=a9399ad9-9fae-4cec-8be1-f084721150cd -e ARM_CLIENT_ID=4c67f96e-d383-46c3-8c07-b9837c3fa0f9 -e ARM_CLIENT_SECRET=f213c981-95e5-4406-bb67-cc18b09ae5bf hashicorp/terraform:light'
  }
  stages {
    stage('Terraform init') {
      steps {
            sh '''
               echo ${storage_key}
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
    stage('Terraform apply') {
      steps {
            sh  '''
                ${terraform} apply -lock=false -input=false tfplan
            '''
      }
    }
  }
}
