# protodoc-server
- `.proto` file viewer on docker
- Inspired by `[glennjones/hapi-swagger](https://github.com/glennjones/hapi-swagger)`

## Preparation
- `/proto/*.proto` files
- ``

## Run locally
- `protodoc-server start`

## Run publicly
- `protodoc-server deploy`

## Route
- `/documentation`

---

## FYI
- `Convox` is AmazonECS wrapper, same like `kubernetes`
- `Dockerfile` and `docker-componse.yml` is on npm repository
- You need to ready `/proto` and `convox` for deployment

## Future work
- convox embedding for convenience
- Always up-to-date protofile generation API