pipeline{
    agent any
    tools{
        maven 'M3'
        //terraform "terraform"
    }
    environment{
        ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
        ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
        ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
        ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
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
                sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'


                }
            }
}
            
        
        stage("create the infra"){
            steps{
                echo "creating the infra"
                //sh 'terraform init'
                //sh 'terraform apply  --auto-approve'
            }
        }
        
        stage("setup the app server"){
                    steps{
                        sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --scripts "sudo apt-get install default-jre -y;\
                            wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz; \
                            tar zxvf apache-tomcat-8.5.73.tar.gz; \
                            mv apache-tomcat-8.5.73/ /opt/apache-tomcat-8.5.73; \
                            ln -s /opt/apache-tomcat-8.5.73/ /opt/tomcat8; \
                            /opt/tomcat8/bin/startup.sh"' 

 
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
