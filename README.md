# Automation-Complete-Java-Application-Deployment

#General:

            This is an automation script to do the following process and result in a complete deployment of a petclinic application (a simple java web application).
          
            1.    Install Tomcat Server.
            2.    Configure Tomcat Server to start with http port as 80.
            3.    Install Mysql Database.
            4.    Reset mysql root user password to welcome1 and run the provided Sql Script.
            5.    Deploy the given Application on tomcat.
            6.    Configure the application with database.
            7.    Start the server.

#Assumptions:

            -> java jdk or jre is installed.
            -> libmysql-java package installed

#Supporting Files:
            
            -> server.xml :- Contains the database server and connection information
            -> web.xml    :- Contains the application specific information

#How to:

            -> Run Automation_Script.sh in the deployment servers with root access.
