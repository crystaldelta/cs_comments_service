FROM forum-ruby-2.4.1:latest
#580093319952.dkr.ecr.ap-southeast-2.amazonaws.com/forum-ruby-2.4.1:latest

RUN apk update

RUN apk add nodejs

RUN apk add git

RUN apk add nginx

WORKDIR /edx/app/forum

RUN addgroup -S forum && adduser -S forum -G forum -h /edx/app/forum

USER forum

#RUN rm Gemfile.lock

#RUN bundle install

#CMD [ "ruby", "app.rb" ]
