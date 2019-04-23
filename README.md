# MT-AWESOME JUST FOR FUN!

A minimize CICD project powered by AWS.

## Workflow

```
                                                             +------------+
                                                             |            |
          +--------+       WebHook             +-------------+--+         | 3. build and unit test
          | GitHub +-------------------------->|     Jenkins    |         | 4. build docker image
          +--------+     1.push event          +--+-+----+------+         | 5. push docker image
              ^                                   | |    |   ^            |
              |                                   | |    |   |            |
              +-----------------------------------+ |    |   +------------+
                         2. pull code               |    |
                                                    |    |
                                                    |    |
                                                    |    |
                                6. create resource  |    | 7. test
                                   with terraform   |    |
                                                    |    |
                                8. destroy resource |    |
                                                    v    |
          +----------------------------------------------|----------------+
          |                            +-----------------|---------------+|
          |                            | ECS Cluster     v               ||
          |    +-----------+           |          +-------------+        ||
          |    |     DB    |<---------------------+   Docker    |        ||
          |    +-----------+           |          +-------------+        ||
          |                            |                                 ||
          |                            +---------------------------------+|
          +---------------------------------------------------------------+
```

## Technology stack

- Golang
- Gin
- Docker
- Jenkins
- Terraform
- AWS ECS
- AWS RDS


