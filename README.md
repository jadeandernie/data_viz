**Solution Explanation:**
All data is stored in backend/src/resources. There are 2 versions of the data, the raw version is what is pulled directly from the source, and the ready version (split into a *_data.json and *_metadata.json) is the output of the backend/src/resources/data_processor.sh script. The idea is to format/preprocess the data ahead of time to save on request time and also to try to mitigate big-data and memory issues.

The ready json files are loaded at request time via GetData.cs to be served at http://localhost:8080/api/fetch. There are optional parameters of limit, position and source. I have only input 3 possible source files, but it would not be a huge stretch to allow dynamic source files via link (though this introduces vulnerabilities and size limitations that I wanted to avoid for the purpose of this test).

The response is picked up by the frontend/lib/handlers/handle_fetch_data.dart, and the data model is correspondingly updated. This state change triggers a refresh to show the data table.

*Key Decisions:*
- To split into metadata and data json files means that 2 files will need to be loaded on each request, and managing multiple file streams is definitely not ideal. However, I decided to go this way to make pagination easier, and with the understanding that in a production ready solution you would be pulling this information from the database rather than the file system, and pulling from 2 tables would be no issue when compared with pulling from 2 different files from the filesystem.
- Preprocessing vs request-time processing I implemented when I went to put in the pagination. With the sample data being all on a single line, it made it both easier to paginate the data by manipulating it ahead of time, and also had additional performance benefits at runtime of already having the columns pulled out and the number of rows, so it seemed like a win-win.

*Notes:*
- In the end, I had to decide on a limit of how much time I would sink into this project, and so things got sloppier towards the end as I tried to wrap things up quickly. Some of the things that in particular fell off were:
* The parameter initialization got quite lazy, just setting inline hard coded inits everywhere
* The tests pass, but that's because I've commented out the broken ones
* The app is fairly buggy with race conditions. I believe it is in part due to the hardware not coping with the dev environment + simulator + docker, but hard to say without testing in a different environment. It seems to work with a few refreshes though.
* I only half-implemented a few features, such as the pagination and limits, though you can hopefully see where I was going with it, even though it is incomplete.
* Responsiveness and testing across different devices was something I definitely ran out of time for.


To Run:

Prerequisites:
* Docker
Note: If you're on mac and have upgraded to sequoia, there are some docker issues you will likely run into. Here are some tips https://romanzipp.com/blog/maocs-sequoia-docker-resetta-is-only-intended-to-run-silicon on how to get things running.
* Flutter SDK

To start backends:
1. `docker-compose build`
2. `docker-compose up`
Main endpoint will be available on http://localhost:8080/api/fetch

To start frontends
Preferably use VSCode to run the simulator with hot reload by clicking the run button. Everything is currently configured to run in debug mode.
Alternatively, you can use `flutter run` in the terminal.



Assumptions:
- Will always want only a single table to be displayed from a single source of data. Have not implemented dynamic segmentation of data into multiple tables based on column groupings.
- The data is sane and doesn't contain any malicious content
- 