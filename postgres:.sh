services:
    postgres:
      image: postgres:13
      environment:
        POSTGRES_USER: airflow
        POSTGRES_PASSWORD: airflow
        POSTGRES_DB: airflow
      volumes:
        - postgres-db-volume:/var/lib/postgresql/data
      healthcheck:
        test: ["CMD", "pg_isready", "-U", "airflow"]
        interval: 5s
        retries: 5
      restart: always

# configuring the docker image, environmental variables, volume mounting, and port connection.
      docker run -it \
        -e POSTGRES_USER="root" \
        -e POSTGRES_PASSWORD="root" \
        -e POSTGRES_DB="scoffie_prac" \
        -v ${pwd}/scoffie_prac_postgres_data:/var/lib/postgresql/data \
        -p 5432:5432 \
        postgres:13


# pg admin

    docker run -it \
        -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
        -e PGADMIN_DEFAULT_PASSWORD="root" \
        -p 8080:80 \
        dpage/pgadmin4

#network
 docker network create pg-network


docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="scoffie_prac" \
  -v ${pwd}/scoffie_prac_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13


# Network with pgadmin

 docker run -it \
      -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
      -e PGADMIN_DEFAULT_PASSWORD="root" \
      -p 8080:80 \
      --network=pg-network \
      --name pgadmin-2 \
      dpage/pgadmin4
