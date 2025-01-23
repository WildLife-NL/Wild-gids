# WildGids
WildlifeNL is a project led by an ambitious team of individuals working together to create a better life for the coexistence between humans and animals. As some of us know, many wild or free-roaming large mammals are returning to the Netherlands. In the 8-year WildlifeNL project (2023-2030), scientists are working together with social partners to investigate how people and wild animals can better coexist within the landscape.

The WildlifeNL project works in seven phases. They have currently reached the second phase of the entire project. In this phase, they need to gather the data required for research in the upcoming phases (or “work packages” as the organization calls them). They aim to collect the necessary data using two mobile apps, so they can analyze and use this information in the following phases for further research.

WildGids is one of the two apps that is mostly going to be used by the recreationist to help gather data from this specific user group. 

## Table of contents
1. [Supported Platforms](#supported-platforms)
2. [Installation](#installation)
3. [Running WildGids](#running-wildgids)
4. [Flavors](#flavors)

## Supported Platforms
- Android
- iOS

## Installation
1. Install Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
2. Clone the repository:
  ```shell
  git clone https://github.com/WildLife-NL/Wild-gids.git
  ```
3. Create a .env. See an example below:
  ```shell
  PROD_BASE_URL="http://localhost"
  DEV_BASE_URL="http://localhost"
  ```
4. Navigate to the project folder and install dependencies:
  ```shell
  cd myapp
  flutter pub get
  ```
5. Run the app on your desired platform:
  ```shell
  flutter run
  ```

## Running WildGids
- To run on Android:
   ```shell
   flutter run
   ```
- To run on iOS (ensure you have Xcode installed):
   ```shell
   flutter run
   ```

## Flavors
We use flavors to manage different configurations for development, staging, and production environments. Flavors ensure that you can switch between environments without modifying the core app code.
- **Development:**
   ```shell
   flutter run --flavor development
   ```
- **Production:**
   ```shell
   flutter run --flavor production
   ```
To build APKs for specific environments:
```shell
flutter build apk --flavor production --release
```