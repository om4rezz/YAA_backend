# YAA™

![YAA logo](https://github.com/YAAapp/YAA/blob/master/assets/logo.png?raw=true)

This repository is part of the source code of YAA. You can find more information at [YAA.com](https://YAA.com) or by contacting opensource@YAA.com.

You can find the published source code at [github.com/YAAapp/YAA](https://github.com/YAAapp/YAA). 

For licensing information, see the attached LICENSE file and the list of third-party licenses at [YAA.com/legal/licenses/](https://YAA.com/legal/licenses/).

If you compile the open source software that we make available from time to time to develop your own mobile, desktop or web application, and cause that application to connect to our servers for any purposes, we refer to that resulting application as an “Open Source App”.  All Open Source Apps are subject to, and may only be used and/or commercialized in accordance with, the Terms of Use applicable to the YAA Application, which can be found at https://YAA.com/legal/#terms.  Additionally, if you choose to build an Open Source App, certain restrictions apply, as follows:

a. You agree not to change the way the Open Source App connects and interacts with our servers; b. You agree not to weaken any of the security features of the Open Source App; c. You agree not to use our servers to store data for purposes other than the intended and original functionality of the Open Source App; d. You acknowledge that you are solely responsible for any and all updates to your Open Source App. 

For clarity, if you compile the open source software that we make available from time to time to develop your own mobile, desktop or web application, and do not cause that application to connect to our servers for any purposes, then that application will not be deemed an Open Source App and the foregoing will not apply to that application.

No license is granted to the YAA trademark and its associated logos, all of which will continue to be owned exclusively by YAA Swiss GmbH. Any use of the YAA trademark and/or its associated logos is expressly prohibited without the express prior written consent of YAA Swiss GmbH.

# How to build the open source client

## Build Status

[![Build Status](https://travis-ci.org/YAAapp/YAA-webapp.svg?branch=dev)](https://travis-ci.org/YAAapp/YAA-webapp)

### Requirements

- Install [Node.js](https://nodejs.org/)
- Install [Grunt](http://gruntjs.com/): `npm install -g grunt-cli`

### Run YAA for Web locally

The first time you run the project you should install the dependencies by
executing the following from your terminal:

```bash
npm install
```

To run the actual server:

```bash
grunt
```

If everything went well the app will be available on
[`localhost:8888`](http://localhost:8888).

### Generate code coverage

```bash
grunt test:coverage
```
