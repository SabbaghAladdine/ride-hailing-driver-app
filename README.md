
#ride-hailing-driver-app

this app simulates the reception of a new ride
while the app is in background (or terminated), and automatically opens the ride detail
screen when the driver taps the notification or receives a socket event. The app should also
support real-time ride updates, use provider for state management, and include a list of
rides with pull-to-refresh and socket-based live updates


## Set Up

This app relies on a springboot static API that provides both a REST API and a STOMP Websocket.
remember to always start the springboot api when testing the application.
A Jar file of the api will be in this repository root.

remember to change the api Ip address in the apiIp.dart file in the commons directory.
## Screenshots

the api contains two requests that you can access using swagger

Swagger Link: localhost:8080/swagger-ui/index.html

/getAll retrieves a static list of posts for the app feed

/ride sends a Stomp message to the app chat room 

this is the message format that needs to be sent in the /group request 
  {"ride_id": "ride_007",
    "pickup": "Masadine",
    "destination": "Sousse",
    "status": "PENDING",
    "passenger_name": "Alaeddine",
    "price": 0.5,
    "timestamp": "2025-05-17T10:30:00Z"}

