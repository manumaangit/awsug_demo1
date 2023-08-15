FROM node:18

WORKDIR /project
COPY package.json .
RUN npm install
COPY . .
CMD ["npm", "run", "start:dev"]
