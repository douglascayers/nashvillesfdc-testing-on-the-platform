# Testing on the Salesforce Platform

This is the sample app used to demo unit, integration, and browser testing at the [Nashville Salesforce Developer Group meetup on April 25, 2019](https://trailblazercommunitygroups.com/events/details/salesforce-nashville-tn-developers-group-presents-april-19-developer-user-group/).

The purpose of the app is in the tests, which show a progression of unit tests focused on particular Apex methods, to larger integration tests of the side effects of processes and triggers to DML updates, to mocking http callouts.

Since Apex testing and Lightning Web Component testing have to mock callouts, they don't give a great picture of how well all the pieces come together in a live environment. The last part of the presentation demoed using [Ghost Inspector](https://ghostinspector.com/) to automate a browser in a live scratch org to perform integration testing.

## Scenario

This app includes a Process and Trigger on the Account record, and a Lightning Web Component on the Account record page that makes an http callout to a web service to retrieve and display that company's stock prices.



When the account's rating becomes "Hot" or "Cold", then the process posts a message to Chatter.

![screen shot](images/process-builder.png)

![screen shot](images/chatter-posts.png)


When the account's ticker symbol changes, then the trigger resets the stock last refreshed date and stock close price.

# Resources

* [Unit Testing on the Lightning Platform](https://trailhead.salesforce.com/en/content/learn/modules/unit-testing-on-the-lightning-platform)
* [Apex Testing](https://trailhead.salesforce.com/en/content/learn/modules/apex_testing)
* [Flow Testing and Distribution](https://trailhead.salesforce.com/en/content/learn/modules/flow-testing-and-distribution)
* [Testing Aura and LWC in a Single Test](https://www.wissel.net/blog/2019/03/testing-aura-and-lwc-in-a-single-test.html)
* [Testing Lightning Web Components](https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.testing)
* [Unit Testing Lightning Web Components with Jest](https://developer.salesforce.com/blogs/2019/03/unit-test-lightning-web-components-with-jest.html)
