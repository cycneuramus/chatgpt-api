FROM public.ecr.aws/docker/library/alpine:3.14 as git

RUN apk add --no-cache --update git

WORKDIR /tmp
RUN git clone --depth 1 https://github.com/acheong08/ChatGPT-to-API/ 

FROM public.ecr.aws/docker/library/golang:1.20 as builder

ENV CGO_ENABLED=0

COPY --from=git /tmp/ChatGPT-to-API /app/ChatGPT-to-API
WORKDIR /app/ChatGPT-to-API

RUN go mod download
RUN go build -o /app/ChatGPT-to-API .

FROM scratch

COPY --from=builder /app/ChatGPT-to-API /app/ChatGPT-to-API
WORKDIR /app/ChatGPT-to-API

EXPOSE 8080

CMD [ "./ChatGPT-To-API" ]
