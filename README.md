# GitDevPlanner

Hello everyone!

I am excited to introduce you to my latest project, GitDevPlanner. This platform has been crafted with passion and dedication to provide developers like you with an efficient way to manage your GitHub repositories, track your activities, and plan future work within the GitHub ecosystem.
![Login Screen]([https://github.com/Alex-RV/Flask/blob/master/static/images/screen_home.png](https://github.com/Alex-RV/GitDevPlanner/blob/main/app/assets/images/screenshots/login_screen.png))

## My Inspiration

As a developer myself, I understand the challenges of managing multiple GitHub repositories and keeping track of tasks and progress. This inspired me to create GitDevPlanner, a centralized space where developers can organize their projects, set goals, and optimize their development workflow. Today, I will delve into the methods used to optimize data fetch, the implementation of delayed jobs, and how the system leverages databases to enhance performance.

## Optimizing GitHub Data Fetch

The core of GitDevPlanner lies in efficiently fetching GitHub repository data for users based on their personal access tokens and nicknames. Retrieving this information quickly is essential for a seamless user experience. To achieve this, the `GithubApiService` class employs the `concurrent-ruby` gem for parallel processing, which significantly reduces response times and enhances overall performance.

```def self.fetch_repos(access_token, nickname)

  promises = all_repos.map do |repo|
    Concurrent::Promise.execute { fetch_last_commit(repo, access_token, nickname) }
  end

  # Wait for all promises to complete
  Concurrent::Promise.zip(*promises).wait
end
```
The `fetch_repos` method retrieves repositories associated with a user's GitHub account. It first fetches the user's repositories and other repositories they are affiliated with, then merges and removes any duplicates. This approach ensures a comprehensive list of repositories is obtained while optimizing the fetch process.

The method also fetches the last commit for each repository in parallel using promises, enabling concurrent processing and faster data retrieval.

## Leveraging Delayed Jobs

Fetching data in real-time can cause delays for users, especially when dealing with a large number of repositories and accounts. To mitigate this, GitDevPlanner employs a delayed job mechanism. The `GithubReposJob` class is responsible for this task, allowing data to be fetched and processed in the background.
```GithubReposJob.perform_later(github_access_token, nickname)```

When a user initiates the fetch process by entering the desired page, the job is queued, and the user can continue using the platform without interruptions. The job performs the data fetch and saves it to the database, ensuring data is always up-to-date while keeping the platform responsive.

## Saving to the Database
![Repos Screen]([https://github.com/Alex-RV/Flask/blob/master/static/images/screen_home.png](https://github.com/Alex-RV/GitDevPlanner/blob/main/app/assets/images/screenshots/repositories_screen.png))

Upon fetching the repository data, the `GithubReposJob` class ensures the relevant information is correctly stored in the database. The job sorts the repositories based on their last commit date to organize the data effectively.
```class GithubReposJob < ApplicationJob
queue_as :default


def perform(github_access_token, nickname)
repos_data = GithubApiService.fetch_repos(github_access_token, nickname)
save_repos_to_db(user, repos_data[:all_repos])
end
def save_repos_to_db(user, repos_data)
repository = Repository.find_or_create_by(name: repo_data[:name], repository_id: repo_data[:repository_id])
repository.update(repo_data)


user.repositories << repository
end
```

For each repository, crucial details like repository ID, name, owner login, HTML URL, privacy status, and the last commit information are saved. This process ensures that users can quickly access their repositories and the associated data without any delay.

## System Design and Functionality

The GitDevPlanner platform offers a user-friendly interface developed with Tailwind CSS, allowing developers to view and manage their GitHub repositories seamlessly. Users can track their activities, set goals, and create plans for future work, all from within the GitHub ecosystem.
![Profile Screen]([https://github.com/Alex-RV/Flask/blob/master/static/images/screen_home.png](https://github.com/Alex-RV/GitDevPlanner/blob/main/app/assets/images/screenshots/profile_screen.png))

The system's architecture incorporates background jobs to handle time-consuming tasks, ensuring a smooth user experience. By implementing delayed jobs, the platform avoids performance bottlenecks, enabling users to interact with the platform without delays caused by data fetching and processing.
![Dashboard Screen]([https://github.com/Alex-RV/Flask/blob/master/static/images/screen_home.png](https://github.com/Alex-RV/GitDevPlanner/blob/main/app/assets/images/screenshots/dashboard_screen.png))

## Conclusion

In conclusion, GitDevPlanner is not just a project; it is a solution to help developers like you streamline your workflow and stay on top of your GitHub repositories. By optimizing data fetch, implementing background jobs, and maintaining an efficient database, GitDevPlanner provides a seamless user experience. I am thrilled to share this platform with you, and I hope it becomes an invaluable tool in your development journey.
