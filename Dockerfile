FROM node:18

WORKDIR /project
COPY package.json .
RUN npm install
COPY . .
RUN cat src/index.ts > test.txt
CMD ["npm", "run", "start:dev"]
