Original App Design Project - README Template
===

# Good Eats

## Table of Contents
1. [Overview](#Overview)
2. [Demo](#Demo)
3. [Product Spec](#Product-Spec)
4. [Wireframes](#Wireframes)
5. [Schema](#Schema)

## Overview
### Description
GoodEats is a food discovery iOS app that helps you discover new food near you and show off all the amazing food you’ve been eating! You can filter restaurants near you, see what’s popular or trendy at a restaurant, and you can even let the app decide what you should eat with a recommendation algorithm.

### App Evaluation
- **Category:** Social / Food & Drink
- **Mobile:** Mobile first experience available anywhere you go; uses camera to take pictures of your dishes and device location services to locate restaurants near you
- **Story:** Allows users to discover new places to eat, receive recommendations, and keep track food they've already tried
- **Market:** Anyone who enjoys eating out and trying new and popular food
- **Habit:** Everytime users are looking for somewhere to eat or are eating out somewhere, they can pull out this app. Also acts as a social media that users can explore through a "feed-like" view so see where their friends have been going
- **Scope:** Posting and viewing feeds

## Demo

### Main Map View + Feed with recommendation, filters, and saving
![mainView](https://user-images.githubusercontent.com/30298846/129426450-d46823c4-3931-4541-93b0-4d22515eee63.gif)

### Compose Page with Yelp API to search for restaurants and Dish autocomplete
![composePage](https://user-images.githubusercontent.com/30298846/129426934-84a4f253-cfda-4f53-a1c5-7d520ebb223f.gif)

### Profile Page withrecent highlights, user's posts, and saved dishes
![profile](https://user-images.githubusercontent.com/30298846/129426937-3f4325c7-dbd5-4bc4-a562-fd35b02ec067.gif)


## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can register a new account
- [x] User can log in
- [x] User can check in to a restaurant
- [x] Users can view a list of places their friends have checked in at in a map view with modally present table view
- [x] Users can view all the dishes at a restaurant sorted by popularity
- [x] Users can upload an image of what they ordered and rate the food


**Optional Nice-to-have Stories**

- [x] Users can filter and sort the list of restarants by rating, distance, frequency of vists, etc.
- [x] Users receive a recommendation of where to go based on their past orders
- [x] Users can search for restaurants near them and select the correct one
- [x] Users can select the dish name out of an autocompleted list of previous dishes people have posted at that restaurant
- [x ] Users can click to get directions to a restaurant
- [x] Users can star restaurants and view them in a separate tab
- [ ] Users can receive a custom generated "food tour" of the day based on other users' recommendations and distances
- [ ] Users can receive recommendations periodically based on the types of food they generally enjoy as well as where friends who have similar tastes to them have enjoyed

### 2. Screen Archetypes

* Login/Register
    * User can register a new account
    * User can log in
* Map View / Stream
    * Users can view a map with pins showing restaurants near them as well as a modal table view of recent posts people have been creating with options to filter results or receive a recommendation
* Detail
    * Users can click into and see more details about posts, dishes, and restaurants
* Profile
    * User can see recent highlights about users, their posts, and saved restaurants
* Creation
    * User can check in to a restaurant with the ability to attach a photo and search for and select the sppropriate restaurant and dish


### 3. Navigation

**Tab Navigation**

* Map View
* Creation
* Profile

**Flow Navigation**

* Login / Signup
    * -> Map View
* Map View
    * -> Restaurant Detail
    * -> Table View Stream
        *  -> Dish Detail
        *  -> Restaurant Detail
    * -> Recommendation Settings
    * -> Filter Settings
* Creation
    * -> Restaurant Search
    * -> Image Picker Screen
    * -> Map View
* Profile
    * -> Saved Dishes Stream


## Wireframes
 [Digital Wireframes](https://www.figma.com/file/qujXlc4uOsPHV5eejyFH50/Good-Eats?node-id=0%3A1) & Mockups
 
![](https://i.imgur.com/EeShffH.png)
![](https://i.imgur.com/lgogKGU.jpg)

## Schema 
### Models

#### Post
| Property    |     Type    |   Description  |
| ----------- | ----------- |   -----------  |
| objectID    | String      | unique id for the user post (default field) |
| createdAt | DateTime| date when post is created (default field) |
|author| Pointer to User | author of post|
| image | File | image that user posts|
| caption    | String      | message or description the user has for this dish |
| rating | Number | number of stars for the meal |
| dish | Dish model | dish the user is posting about ||
| tags | Array of Tags | tagged descriptions of meal |

#### Restaurant
| Property | Type | Description |
| ----------- | ----------- |   -----------  |
| objectID    | String      | unique id for the restaurant (default field) |
| name | String | name of the restaurant|
| dishes | Array of Dishes | all the dishes at this restaurant |
| latitude | Number | lattitude location of the restaurant |
| longitude | Number | longitude location of the restaurant |
| abrevLocation | String | City, State location of restaurant |
| numCheckIns | Number | total number of checkins that have been made at this restaurant |

#### Dish
| Property | Type | Description |
| ----------- | ----------- |   -----------  |
| objectID    | String      | unique id for the dish (default field) |
| name | String | name of the dish|
| restaurantName | String | name of the restaurant that sells this dish |
| restaurantId | String | object Id of the restaurant that sells this dish |
| avgRating | Number | average rating for this dish out of 5 |
| numCheckIns | Number | total number of checkins that have been made at this restaurant |


### Parse Networking

- Login
    - (GET) Query existing users with specified username + password
- Sign up
    - (GET) Query existing users to ensure there is no existing username with the specified username
    - (POST) Create a new user with specified username + password
    
- Map View
    - (GET) Query all restaurants
    - Filter View
        - (GET) Query all restaurants with filter constraints
            - (GET) subqueries on dishes and posts of dishes to relate tags to restaurants
    - Recommendation View
        - (GET) Query all restaurants with contraints depending on user input and trends
        - (GET) Query all posts to determine the dishes the user has or has not already tried
- Modal Table View screen
    - (GET) Query all posts with dishes at restaurants currently displayed on the map view
- Dish detail screen
    - (GET) Query all posts where dish field is the selected dish
- Restaurant detail screen
    - (GET) Query all posts where the restaurant field is the selected restaurant
- Profile Screen
    - (GET) Query logged in user object
    - (PUT) Update user profile image
    - (GET) Query all posts where author is the logged in user
- Create Post Screen
    - (POST) Create a new post object



### [Yelp API](https://cocoapods.org/pods/YelpAPI)
- Business Search for businesses with specified term, location, and category
