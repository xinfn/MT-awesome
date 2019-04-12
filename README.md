# MT-AWESOME JUST FOR FUN!

A minimize CICD project powered by AWS.

## Workflow

```
                                                     +------------+
                                                     |            |
  +--------+       WebHook             +-------------+--+         | 3. build and unit test
  | GitHub +-------------------------->|     Jenkins    |         | 4. build docker image
  +--------+     1.push event          +--+-+---+-------+         | 5. push docker image
      ^                                   | |   |    ^            |
      |                                   | |   |    |            |
      +-----------------------------------+ |   |    +------------+
                 2. pull code               |   |
                                            |AWS|
                                            |CLI|
                             6. start EC2   |   | 8. test
                             7. pull docker |   | 9. destroy EC2
                                image       |   |
                                            v   v
  +----------+                         +----------------+
  |    DB    |<----------------------->|     server     |
  +----------+                         +----------------+
```

## Technology stack

- Golang
- Gin
- Docker
- Jenkins
- AWS EC2
- AWS RDS
