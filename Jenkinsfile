pipeline{
    agent any
    tools{
        maven 'M3'
        //terraform "terraform"
    }

    }
    stages{
        stage('Build & Unit Tests'){
            steps{
                sh 'mvn clean verify -DskipITs=true'
                junit allowEmptyResults: true,testResults: '**/test-results/*.xml'
                archive 'target/*.jar'

            }
        }

         
        stage("azure login"){
            steps{
                withCredentials([azureServicePrincipal('azure-sp')]) {
                //sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                sh 'export ARM_SUBSCRIPTION_ID="43a2c14f-6eb2-431b-bdb8-a34bacea87a5"'
                sh 'export ARM_CLIENT_ID="a06ec21f-7ebc-46f0-97b4-2251138b983e"'
                sh 'export ARM_CLIENT_SECRET="$AZURE_CLIENT_SECRET"'
                sh 'export ARM_TENANT_ID="8a74b133-da15-4122-ae11-89841e76d91b"'

                }
            }
}
            
        
        stage("create the infra"){
            steps{
                echo "creating the infra"
                sh 'terraform init'
                sh 'terraform apply  --auto-approve'
            }
        }
        
        stage("setup the app server"){
                    steps{
                        withCredentials([azureServicePrincipal('azure-sp')]){
                        sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                        sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --scripts "sudo apt-get install default-jre -y;\
                            wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz; \
                            tar zxvf apache-tomcat-8.5.73.tar.gz; \
                            mv apache-tomcat-8.5.73/ /opt/apache-tomcat-8.5.73; \
                            ln -s /opt/apache-tomcat-8.5.73/ /opt/tomcat8; \
                            /opt/tomcat8/bin/startup.sh"' 
                        }
 
                    }
                }

                

        stage("deploying the app"){
                    steps{
                        echo "deploying the app"
                    }

                }
                    
            
        stage("destroy the infra"){
            steps{
                echo "destroying the azure vm"
            }
        }
        
    }
    
}
