FROM nginx:alpine

COPY my-custom-content/ /usr/share/nginx/html/
COPY my-custom-content/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
