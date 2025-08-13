# Eventorias

## Summary

* [Description](#description)
* [Installation](#installation)
* [Features](#features)

## Description
Eventorias ....

## Installation

### Clone the repository
```shell
git clone https://github.com/ThibaultGiraudon/Eventorias.git
```

### Create files

- #### Secrets.xcconfig
Onnthe project page tap `cmd + n`, choose `Configuration Settings File` and named it `Secrets.xcconfig`.
Then inside this file add:
```
API_KEY = googleMap_API_key
```
> [!NOTE]
> *See [this page](https://developers.google.com/maps/documentation/maps-static/get-api-key?hl=fr&setupProd=prerequisites) to get your own api key.*

 - #### GoogleService.plist:
Go on [Firebase](https://console.firebase.google.com/) and create a new app with your Bundle Identifier.
You can get yours following those steps :

![alt text](assets/Bundle-Id.png)

Than add Storage and Database and Authentification. Don't forget to change the rules:

- ##### Storage:
```
rules_version = '2';


service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

- ##### Database:
```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Features

### Firebase Integration 
All Firebase-related operations are encapsulated within dedicated repository classes, such as `AuthRepository`, `StorageRepository`, `UserRepositor`y, and `EventRepository`.
Each repository is responsible for interacting with a specific Firebase service, isolating implementation details from the rest of the application.
This architecture prevents direct dependencies on Firebase APIs within ViewModels or other components, making the codebase cleaner, more maintainable, and easier to refactor.
By centralizing these operations, switching to another backend provider or modifying the data layer can be done with minimal changes to the business logic.

### Authentication
Users can create an account, sign in, and sign out using Firebase Authentication.
The authentication logic is fully handled by the AuthRepository, accessed through the corresponding `AuthenticationViewModel`.

### Profile Editing
Authenticated users can update their profile information, such as display name, profile picture, and other personal details.
UI interactions go through a `UserSessionViewModel`, which delegates updates to the respective repository.
The `UserRepository` manages Firestore updates for profile data and the `StorageRepository` manages Firebase Storage to uploads images.

### Event Creation
Users can create new events by providing a title, description, date, location, and image.
The `AddEventViewModel` validates inputs and then delegates persistence to the `EventsRepository` and `StorageRepository`.

### Event Details
Users can see event's detail such as title, description, date, location and image.
The `EventViewModel` handles fetching the event's creator and the subscription.

### Event List & Calendar View
Events are accessible in two formats:

- List View: A scrollable list showing upcoming events with essential details.

- Calendar View: An interactive calendar displaying events on their scheduled dates.
Both views use `EventsViewModel` to retrieve data from the `EventsRepository`.

### Search & Filters
Users can search for events by applying filters such as date, title, or location.
The `EventsViewModel` handles the filtering and searching logic locally on fetched data for optimal responsiveness.

