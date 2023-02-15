FROM nginx
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./react-calculator/build /usr/share/nginx/html
