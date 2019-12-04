# sample graphql service connecting to AWS SQS

provides a graphql/graphiql interface for sending a message to sqs and receiving a message from sqs

requires:

- create a SQS queue
- create access permissions
- set AWS credentials via ENV / env file if using docker

## Getting started

ops/$ make init
ops/$ make plan
ops/$ make apply

$ make install_dependencies
$ make run_as_iam_role

GraphQl:
send 
```
mutation {
  sendMessage(msg: "hey")
}

```
receive:
```
{
  receiveMessage
}
```


bindata
$ go-bindata -o bindata2.go graphiql.html schema.gql 