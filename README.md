# GitHubStargazers
A simple iOS exercise. Given an owner and a repository, the application will show the list of that repository stargazers.

## Structure
The application is very simple, with only two views. The user can interact with the main view, inserting the search parameters (ownre and repo).
When the API call returns its result, the user will be shown the stargazers list.

The stargazers are shown as a list in a tableview, and the stargazers pagination is handled with the infinite scroll technique.
When the user scrolls down to the end of the tableview, a new API call is made. The new call requests new page of results, that follows the page
retrieved with the previous call. This only happens if the API call returns n = m stargazers, where n is the number of stargazers andm is the
maximum number of stargazers requested per page.
