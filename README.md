# Lodeals
TL;DR: An iOS app for finding and rating food establishments by the deals they offer


Description
Lodeals is an iOS app that allows users to search for food deals in the area based on basic business search calls to the Yelp Fusion API, such as the name of the establishment and location. Google Maps allows for a more visual representation of nearby businesses. Users add deals for particular restaurants, which automatically initiates writes to Cloud Firestore. Selecting a business of interest will segue to a detailed view, where users can offer their input by adding new deals or confirming whether or an existing deal has worked for them.


Master View Controller (MasterVC)
Purpose: Features a number of businesses along with respective basic information whose data is populated through Yelp API calls and can be customized with specific search input

Makes a Business Search request call to the Yelp API to create an array of Restaurant objects
By default, the search call uses the user’s current location coordinates as parameters
Loads the uitableviewcells with data from those Restaurant objects asynchronously with DispatchQueue in order to quickly appear on screen (no need for loading screen)
For further loading speed, a default count of 23 (my lucky number) Restaurant objects is created and loaded
Because only one image is needed for each restaurant (an icon image in each cell), only one is saved locally
Upon returning from DetailsVC (segue from the save button), update the specific Restaurant object and reload uitableview to display any changes made
Before anyone submits any deals, each uitableviewcell will display “currently no deals”


Details View Controller (DetailsVC)
Purpose: Displays in-depth information for a single business and allows for the opportunity to view, verify, and add deals

Image Loading:
Asynchronously loads images (up to 4 as of now) using DispatchQueue
The upper left x value of each image is set depending on its index, allowing for a space between each and hopefully a cleaner UI experience
The y value is determined using the tagsLabel (categories) above, whose frame is also set dynamically:
Image y value = tagsLabel’s y value + tagsLabel’s height + a buffer of 8
I wrote two functions to handle the layout:
CGRect() initializer sets the x, y, width, and height values
NSLayoutConstraints programmatically sets appropriate constraints
Note: I wrote two just for practice and better understanding of the Swift language; I only actually called one
To-Do: Expand to view more images; Tap to view enlarged image with caption if present
Stretch Goal: Allow for uploading of images, then store in the database and potentially link to a specific Deal

Deals Table View:
Uses a custom view for header from a xib file, DealSectionHeaderView, to represent each cell, displaying a short description of the deal as well as when it was last used and a verify action button
Tapping the + button next to the “last used” label in the DealsVC initiates a push segue to AddDealVC
Verification:
When you verify a deal, the button will change color and text, and the last used time will update to “...0 min ago”
If you unverify a deal, it will return to the original color, text, and last used time
Note — Bug: At this point, if you create a new deal and then try to unverify it, there will be an error because lastUseStr now will refer to nothing and I have not yet focused on resolving this
Cell Expansion:
Upon tapping the header (anywhere except within the action button), the cell will expand to show additional details/description of the selected deal
Tapping an expanded cell will collapse to just its original header
An array of boolean values, dealIsExpanded, represents whether each deal should be expanded or not
In viewDidLoad(), each element in dealIsExpanded is set to false
Upon unwinding from ConfirmAddDealVC, the only cell that is expanded is the newly added one
To-Do: Display Yelp information such as rating and review count; Add a link to and automatically load upon click the particular Yelp page


Add Deal View Controller (AddDealVC)
Purpose: Allows users to enter text that represent a new deal they intend to add

A uitextfield and uitextview serve as points of input
The clear button clears all of the text in both
The done button triggers a push segue to ConfirmAddDealVC, passing in the data typed into the fields
To-Do: After tapping the done button, trigger an error pop-up notification if either the uitextfield or uitextview remains unfilled, the short description is too long, or (optional) if the either sounds too similar to a previously submitted Deal


Confirm Add Deal View Controller (ConfirmAddDealVC)
Purpose: Provides the opportunity for users to review their input and choose to either confirm or cancel the creation of that new deal

Displays the information previously entered before the segue, as well as basic Restaurant data
The cancel button returns to its DetailsVC without saving any data
The confirm button also triggers an unwind segue to DetailsVC but furthermore:
Saves and instantiates the new Deal object
Appends it to the restaurant’s deals array
Reloads the Deals uitableview to include the newly created object with its verification button already set


Yelp Fusion API
Purpose: To retrieve business information through its Business Search and Business Details endpoints, as well as aid in the user’s search with the Autocomplete endpoint

Use JSONDecoder() to create a struct object from JSON data returned from the API request made in the Restaurant class function getRestaurantsFromSearch()
Calls getRestaurantsFromStruct(), which parses the struct to populate (and later return) an array of Restaurant objects
Personal Note: I have struggled greatly to implement the Yelp Fusion API. In addition to having little documentation and online help, many of the resources I have found online are outdated and elicited much time and frustration. Some of the problems I faced involve:
Difficulty understanding Yelp’s limited specs
Attempting to write my own Yelp Client (and utterly failing)
Trying to use outdated AFNetworking and BDBOAuth1Manager Pods (and utterly failing)
Trying to use confusing YelpAPI and BrightFutures Pods (and utterly failing)
Handling unwanted asynchronous versus synchronous behavior (though this is less of an API issue)
Even just figuring out how to make API requests with the appropriate request header and no client secret
Ultimately, I am glad I powered through because I believe it is the most relevant to my app (as opposed to Foursquare and Google, for example) in particular, and I have also learned a lot about API implementation


Cloud FireStore
Purpose: To store data externally and easily write and access information

I have connected CloudStore to my app and have written functions to pass in and retrieve data, which I have also tested
Before reloading the restaurant uitableview in MasterVC, if a particular restaurant is found in the database (matching unique id’s), it should update its Deals
Upon creation of a new Deal, ConfirmAddDealVC will automatically write to the database
Note: In this prototype, I am currently not yet writing and reading to Cloud Firestore although I have it set up for implementation in the near future
To-Do: Update data occasionally in the case it changes in the Yelp API and is no longer up to date in my database


Google Maps
Purpose: To display nearby businesses and allow for specialized search by map or annotation data

Tapping the Local button in MasterVC segues to MapViewController, which simply contains a map view and uitextfield
Automatically zooms to the user’s current location by default
A GMSMarker highlights the exact user location with an appropriate snippet
To-Do: Finish implementation (pin nearby restaurants with appropriate markers and update if the map view changes)


Data Structures and Functions
Currently, Lodeals utilises an array of Restaurant objects stored locally, each containing an array of Deal objects
Both the Restaurant and Deal class have been fleshed out much more than originally detailed in Milestone 2
This array is reset with each new user search (populated from Yelp API Business Search requests)
Only once a Deal is added will its parent Restaurant appear in Cloud Firestore; therefore, at the app’s birth, all Restaurant objects will have an empty Deal array and the database will not contain any data
To-Do: Handle valid times for Deals and import Restaurant hours
Pre-populated text for all uitextfields/views clears upon first edit
Since only certain data components are displayed in MasterVC, the Restaurant class function getRestaurantsFromSearch() only saves relevant information
After tapping on a cell, in DetailsVC, class function getBusinessDetails() updates the selected Restaurant with additional data retrieved from the Yelp API Business Details request such as all images uploaded to Yelp and phone number
The unique business id is used as the reference key for each Restaurant both in local object instantiations and in the database


Next Steps
To-Do items previously mentioned
Personalized search with text autocomplete using Yelp API Autocomplete endpoint
Write an algorithm for sorting: 1. Deals based on the number and recency of its verifications and 2. Businesses according to current deals search, relevancy of verifications, and specified/current location
Implement a “load more” button in MasterVC to load another set of restaurants from the specific search parameters
Allow for comments/tips on each Deal such as “Promotions/discounts are not stackable”
Implement a “Report Deal” function for deals that no longer work
Note: I am no longer going to support creating new Restaurant objects. Since I am now successfully populating my data with the Yelp API, I will simply allow it to do that work for me and start writing to my own database when a Restaurant has at least one Deal submitted





