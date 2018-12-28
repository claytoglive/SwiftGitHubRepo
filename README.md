# SwiftGitHubRepo
Demo for using Swift to access the GitHub API

This demonstrates authenticating using the ASWebAuthenticationSession class as specified in https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession

1) To gain a client_id, an OAuth app needs to be registered with github.
From Settings->Developer settings, press "New OAuth app".
Then complete all the details, and a client id and secret will be generated.
Enter the Callback URL, for example, "SwiftGitHubRepo://" (exclude double quotes).

2) When connecting to an authentication url such as https://github.com/login/oauth/authorize?client_id=<client_id>
where <client_id> should be replaced with the actual client_id.
This will provide a code.

3) Next the access token needs to be gained by the URL 
https://github.com/login/oauth/access_token?client_id=<client_id>&client_secret=<client_secret>&code=<code>
Where <client_id> should be replaced with the actual client_id, and <client_secret> should be replaced with the actual client secret, and <code> should be replaced with the actual code returned from the previous step.

4) Once the access token is returned, this can be used to access the various GitHUb API such as https://api.github.com/user/repos?access_token=<access_token>
Where <access_token> should be replaced with the actual access token.
