# DevOps / Site Reliability Engineer - Technical Assessment
Our tech teams are curious, driven, intelligent, pragmatic, collaborative and open-minded and you should be too.
## Testing Goals
We think infrastructure is best represented as code, and provisioning of resources should be automated as much as possible.	We are testing your ability to implement modern automated infrastructure, as well as general knowledge of operations. In your solution you should emphasize readability, security, maintainability and DevOps methodologies.

## The Task
Your task is to create a CI/CD pipeline that deploys this web application to a load-blanced environment on AWS Fargate / EKS.

You will have approximately 1 week to complete this task and should focus on an MVP but you are free to take this as far as you wish.
## The Solution
You should create the infrastructure you need using Terraform or another Infrastructure as Code tool. You can use any CI/CD system you feel comfortable with (e.g. Jenkins/Circle/etc) with but the team have a preferences for GitHub actions.

Your CI Job should:
- Run when a feature branch is pushed to Github (you should fork this repository to your own Github account).
- Deploy to a target environment when the job is successful.
- The target environment should consist of:
  - A load-balancer accessible via HTTP on port 80.
- The load-balancer should use a round-robin strategy.

**We recommend staying within the free AWS tiers so you don't incur costs as unfortunately these can't be reimbursed**
 ## The Provided Code
 This is a NodeJS application:

- `npm test` runs the application tests
- `npm start` starts the http server

## When you are finished
Create a public Github repository and push your solution including any documentation you feel necessary. Commit often - we would rather see a history of trial and error than a single monolithic push. When you're finished, please send us the URL to the repository.
