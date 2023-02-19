## LIGHT DOCKER AND SQL PRACTICE (POSTGRD AND PGADMIN)

This is a light project that helps us learn how to use postrges and pgAdmin locally using **Docker** containers without having necessarily to download the two softwares. Also, if already downloaded, the two containers will not confict with the already downloaded software and thus we can do development as we deem fit.
Also we will perform some **CRUD** operations to create tables of sql practice as well as some answering some questions using sql queries. 


**side note**: 
* _Docker image is a snapshot of all the instructions you container has_.
* _Spark is a thing for definiing datapipelines and we can use docker images to specify the dependecies needed for job orchestration of a pipeline using spark_

We need to pull the docker image of postgres to be able to use it. Airflow docker image has an instance of postgres and therfore we can use that to fire up our own postgres container.

#### Step 1:
Pulling the docker postgres image. We will use the one that is instanciated along with Airflow docker image _postgres13_.
Run this on your terminal to get the postgres container up and running. The env. varibles are repped using the _-e_ flag; volume mounting using _-v_
and _-p_ for port mapping to the host machine.
 ```docker run -it \
        -e POSTGRES_USER="root" \
        -e POSTGRES_PASSWORD="root" \
        -e POSTGRES_DB="scoffie_prac" \
        -v ${pwd}/scoffie_prac_postgres_data:/var/lib/postgresql/data \
        -p 5432:5432 \
        postgres:13
 ```

 #### Step 2-A:
 Run a cli client for accessing the database on the terminal. we use the **pgcli** client. You can use the 

 `pip install pgcli` to install it .

 Run the command `pgcli -h localhost -p 5432 -u root -d scoffie_prac`

These are the db configurations required to access postres db;
**host**
**port**
**user**
**database**

The alternative to this is using a database administrator such as PGADMIN. Which is what I am going to use.


#### Step 2-B:
We now have to run the pgAdmin container 

``` docker run -it \
      -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
      -e PGADMIN_DEFAULT_PASSWORD="root" \
      -p 8080:80 \
      dpage/pgadmin4
```
Parameters:
pgadmin configs default_email and password.
map a port on host machine `8080` and forwARD TO port `80` on the container. All requests sent to port 8080 will b forward to port 80.

When it is up an running, we cant be able to connect the pgAdmin to the postgres database since they are both running in different containers, therefore, we need to connect the two containers so that they can communicate. Enter _pg networks_.

So we stop both the containers and start configuring the network that will connect them both

### Step 3 
First create a docker network by running 
`docker  newtork create pg-network` on terminal.

Then run the postgres container up again with the network infused.

```docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="scoffie_prac" \
    -v ${pwd}/scoffie_prac_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg-network \
    --name pg-database \ 
     postgres:13
 ```
 the name: _this is how pgadmin knows how to connect to the postgres db_

Network with pgadmin


``` docker run -it \
      -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
      -e PGADMIN_DEFAULT_PASSWORD="root" \
      -p 8080:80 \
      --network=pg-network \
      --name pgadmin \
      dpage/pgadmin4
```
