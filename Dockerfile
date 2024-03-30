# Use an official Node.js, and it should be version 16 and above
FROM node:lts AS build
# Set the working directory in the container
WORKDIR /app
# Copy package.json and pnpm-lock.yaml
COPY pnpm-lock.yaml package.json ./
# Install app dependencies using PNPM
RUN npm install -g pnpm
# Install dependencies
RUN pnpm i 
# Copy the application code 
COPY . .
# Build the TypeScript code
RUN pnpm run build
# Expose the app
FROM nginx:alpine AS runtime
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 9000
# Start the application
CMD ["pnpm", "start"]
