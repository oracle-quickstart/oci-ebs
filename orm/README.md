# **Create Oracle E Business Suite Infrastructure using Resource Manager Service**
You can also create Oracle E Business Suite Infrastructure on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure) using [Resource Manager Service](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm) in OCI console or OCI CLI.  


## **Deployment Steps**

  1. Generate Resource Manager Stack zip file using steps below. 

        ```
        git clone https://github.com/oracle-quickstart/oci-ebs.git
        cd oci-ebs/orm 
        terraform init     
        terraform apply
        ```
     You should now see a zip file under orm/dist/ folder. 

  3.  Create a Resource Manager Stack via console/CLI using steps documented [here](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/samplecomputeinstance.htm#build).