# Star the project with docker compose 

```
docker compose up
```

# Run the tests

```
docker compose exec backend sh -c "mix test"
```

# Running locally 

Use asdf to install the correct versions of erlang and elixir

# Notes

To parse the page, I used a library called Floki. Sometimes the HTML comes with non-UTF-8 characters. I used a library called Codepagex to eliminate those characters (iconv was a better option, but this one was good enough for this small project). The analysis of the scrapping of the pages is done right there in the request process; thus, it will only respond when we finish the scrapping of the links. This is a very simple and naive approach; a message queue (SQS, RabbitMQ) would be the ideal solution, but that adds a lot of complexity to the project, and we only have a day. Thus, the simple but flawed solution was implemented, and with more development time, this could be improved significantly. 

The project needs more tests, I only added the "happy path" tests but, Due to the time constraint of the assignment, I prioritized only the most essentials tests.
