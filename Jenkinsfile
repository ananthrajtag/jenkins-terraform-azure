pipeline {
  agent {
      node {
          label 'master'
      }
  }

  environment {
      ARM_SUBSCRIPTION_ID = 175f0376-6221-48ff-947b-37005e74e5df
      ARM_TENANT_ID = a9399ad9-9fae-4cec-8be1-f084721150cd
      ARM_CLIENT_ID = 4c67f96e-d383-46c3-8c07-b9837c3fa0f9
      ARM_CLIENT_SECRET = f213c981-95e5-4406-bb67-cc18b09ae5bf

      storage_key =
      terraform = 'docker run -v /var/lib/jenkins/workspace/TerraformAzure:/var/lib/jenkins/workspace/TerraformAzure:rw,z -w /app -v /var/lib/jenkins/workspace/TerraformAzure:/app hashicorp/terraform:light'
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
               export ARM_SUBSCRIPTION_ID ARM_TENANT_ID ARM_CLIENT_ID ARM_CLIENT_SECRET
               echo $ARM_SUBSCRIPTION_ID $ARM_TENANT_ID $ARM_CLIENT_ID $ARM_CLIENT_SECRET
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
