pipeline{
    agent any
        
    stages{
        stage('Build & Unit Tests'){
            steps{
                sh 'mvn clean verify -DskipITs=true'
                junit '**/target/surefire-reports/TEST-*.xml'
                archive 'target/*.jar'

            }
        }

        stage("Deployment"){    
            stages{
                stage("creating the vm"){
                    steps{
                        echo "creating the vm"
                    }
                }

                stage("setting up application server"){
                    steps{
                        echo "setting up app server "
                    }
                }

                stage("deploying the app"){
                    steps{
                        echo "deploying the app"
                    }

                }
                    

            }
        }
            
}
}