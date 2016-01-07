# ReadingWaves

A simple iOS app that displays Books related to the Ocean and their data

Notes:

* Data is pulled synchronously while the splash screen is showing. This could be changed to asynchronous with notifications or delay the fetch until the MasterViewController loads. 
* The data load is a tad slow because the details for each book are all gathered at once. Realistically this could be done dynamically when the Detail view controller is shown, but for now this works. 
* I am only grabbing 20 titles just to show the concept. This could be changed to a higher value of course. 
