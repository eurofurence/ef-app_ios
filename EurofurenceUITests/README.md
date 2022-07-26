#  UI Tests

The UI tests in this target are designed to exercise a mixture of primary feature pathways (as a substitute for loads of manual regression testing), alongside several bugs that are worthwhile keeping an eye on. They are designed to remain executable in any order, and in any existing state of the application. However keep in mind running these tests on a device where you're interested in keeping the data is not wise - there are no guarantees the data will remain in a desirable state following their execution.

## Authentication

Some tests make use of authenticating as a test user in order to exercise a few other pathways. These credentials are made available to the test through the use of a property list - namely TestAccountCredentials.plist. 

This plist contains the key value pairs the test expects to decode, but does not contain the credentials within the repository (as this would be a _bad thing_). Substitute these values for any account you please, just don't commit them to source. :) 
