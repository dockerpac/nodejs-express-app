FROM node:14.8.0-stretch-slim

ENV PROJECTDIR /app
ENV PORT 3000

RUN mkdir /app
WORKDIR /app
COPY . .
RUN npm install

EXPOSE 3000

CMD ["npm", "start"]
