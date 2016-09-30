# GitCrash

###About The APPlication

This application uses the GitHub web API to retrieve all open issues associated with the Crashlytics repository.
- Display a list of issues to the user based on most-recently updated issue first
    - Issue titles and first 140 characters of the issue body is in the list
    - Allows the user to tap an issue to display next screen (detail screen) containing all comments for that issue.
    - The complete comment body and user name of each comment author is shown on this screen.
    - Uses a persistant storage where the data is updated in every 24 hours
    - ability for the user to retry fetching data from the server in case of No internet connection
