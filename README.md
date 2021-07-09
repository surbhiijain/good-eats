Original App Design Project - README Template
===

# Good Eats

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Keep track of and share with your friends the restaurants you're going to, what you're getting, and what you thought! 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social / Food & Drink
- **Mobile:** Mobile first experience available anywhere you go, uses camera to take pictures of your dishes and "check-in" at restauarants
- **Story:** Allows users to keep track of where they've eaten and what they bought as well as discover new places their friends recommend
- **Market:** Anyone who enjoys eating out and also has friends who enjoy eating out and trying new things!
- **Habit:** Everytime users are looking for somewhere to eat or are eating out somewhere, they can pull out this app. Also acts as a social media that users can explore through a "feed-like" view so see where their friends have been going
- **Scope:** Posting and viewing feeds of food; following friends

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can register a new account
* User can log in
* User can search for and follow friends
* User can check in to a restaurant
* Users can view a list of places their friends have checked in at both in a table view and map view, filtered by distance

**Optional Nice-to-have Stories**

* Users can upload an image of what they ordered and rate the food
* Users can click to get directions to a restaurant
* Users can filter and sort the list of restarants by rating, distance, frequency of vists, etc.
* Users can star restaurants and view them in a seprate tab
* Users can receive a custom generated "food tour" of the day based on friends' recommendations and distances
* Users can receive recommendations periodically based on the types of food they generally enjoy as well as where friends who have similar tastes to them have enjoyed
* Users can see how similar their tastes are to their friends

### 2. Screen Archetypes

* Login/Register
    * User can register a new account
    * User can log in
* Stream
    * Users can view a list of places their friends have checked in at in a table view and map view
* Detail
    * Users can click into and see more details about the friend's restaurant experience
* Stream / Profile
    * User can search for and follow friends
* Creation
    * User can check in to a restaurant


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Stream
* Create
* Profile

**Flow Navigation** (Screen to Screen)

* Login
    * Stream
* Stream
    * Detail
* Profile
    * Detail
* Creation
    * Stream

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/6NwQxop.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups
![](https://i.imgur.com/2ynAN3j.png)


### [BONUS] Interactive Prototype

## Schema 
### Models

Post
| Property    |     Type    |   Description  |
| ----------- | ----------- |   -----------  |
| objectID    | String      | unique id for the user post (default field) |
|author| Pointer to User | author of post|
| image | File | image that user posts|
| rating | Number | number of stars for the meal |
| restaurant | Restaurant model | the restaurant the user checked-in to |
| food | String | name of the meal the user ordered|
| tags | Array of Tags | tagged descriptions of meal |
| createdAt | DateTime| date when post is created (default field) |

Restaurant
| Property | Type | Description |
| ----------- | ----------- |   -----------  |
| name | String | name of the restaurant|
|location | Location model | where the restaurant is located |
| tags | Array of Tags | tagged descriptions of the resturant |
|posts | Array of Posts | all the posts at this restaurant |

Location
| Property | Type | Description |
| ----------- | ----------- |   -----------  |
| streetAdress | String | street address of location |
| city | String | city located in|
|state| String | state located in |
| latitude| Number | latitude for pinning to a map and directions|
| longitute | Number | longitude for pinning to a map and directions|

Tag
| Property | Type | Description |
| ----------- | ----------- |   -----------  |
| name | String | name of the tag|
| description | String| short description explaining the tag|


### Networking
- [Add list of network requests by screen ]
- Home feed screen
    - (Read/GET) Query all posts with different predicates depending on filters
- Restaurant detail screen
    - (Read/GET) Query all posts where restaurant field is the selected restaurant
- Profile Screen
    - (Read/GET) Query logged in user object
    - (Update/PUT) Update user profile image
    - (Read/GET) Query all posts where author is the logged in user
- Create Post Screen
    - (Create/POST) Create a new post object

- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
