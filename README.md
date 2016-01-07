# ReadingWaves

A simple iOS app that displays Books related to surfing.

Uses a Master-Detail layout. The Master layout show titles found and their authors, while the Detail view shows metadata found about the Book selected.

This application uses the [OpenLibrary API](https://openlibrary.org/developers/api) to query books and information. 

###Notes

* Data is pulled synchronously while the splash screen is showing. This could be changed to asynchronous with notifications or delay the fetch until the MasterViewController loads. 
* The data load is a tad slow because the details for each book are all gathered at once. Realistically this could be done dynamically when the Detail view controller is shown, but for now this works. 
* I am only grabbing 20 titles just to show the concept. This could be changed to a higher value of course. 
