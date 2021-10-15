## Stage-1: 
## Build image ~300MB
FROM node:16 as build

WORKDIR /app
COPY ./src /app/

RUN npm install

## Stage-2: 
## Deployment image ~70MB
FROM node:16-slim

WORKDIR /app 
COPY --from=build /app .

EXPOSE 3000

CMD ["node", "index.js"]
