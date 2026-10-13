# NTUA ECE Human-Computer Interaction Project

This repository showcases the application architecture, user interface design, and full-stack implementation for Cellar Sage, an interactive wine scanning and social review platform developed for the Human-Computer Interaction course at the National Technical University of Athens (NTUA), School of Electrical and Computer Engineering. Through this coursework, I focused on user-centered design methodologies, intuitive navigation flows, and social gamification systems, engineering a cross-platform mobile frontend with Flutter/Dart coupled to a lightweight Python Flask REST service and an event-driven MySQL relational database.

## Project Modules & System Implementation

### Mobile Client & User Experience (Flutter / Dart)
*Design and implementation of a responsive, mobile-first interface prioritizing visual hierarchy, input validation, and real-time state feedback.*

* **Key Tasks:**
  * **Authentication & Onboarding (`login_page.dart`, `registerscreen.dart`):** Structured user registration and login workflows with asynchronous validation, persistent session states, and feedback dialogues for duplicate credentials.
  * **Discovery Dashboard & Navigation (`homescreen.dart`, `navbar.dart`):** Built a centralized home feed showcasing recent label scans and community tasting highlights, bound together with a persistent bottom navigation shell for view routing.
  * **Bottle Scanning & Information Lookup (`scanscreen.dart`, `scanresults.dart`):** Implemented an interactive camera-assisted scan simulation yielding detailed bottle metadata, tasting profiles, grape composition, and aggregate ratings.
  * **Community Feedback & Reviews (`userreviewsscreen.dart`):** Created a multi-criteria review submission workflow featuring dynamic 5-star scoring, text critiques, and upvote counters.
  * **Gamification & Profile Analytics (`leaderboardscreen.dart`, `profilescreen.dart`):** Designed an interactive community leaderboard ranking users by accrued "Sage Points," alongside a personal user dashboard summarizing total scans, authored notes, and peer upvotes.
* **Tech Stack:** Flutter, Dart, Material Design, Asynchronous State Management.

### Backend Services & Business Logic (Python Flask)
*Development of a decoupled RESTful service layer orchestrating API routing, query execution, and payload serialization.*

* **Key Tasks:**
  * **REST API Routing (`app.py`, `routes.py`):** Structured a Flask Blueprint architecture serving dedicated endpoints for account lifecycle management (`/insert_user`, `/login`), bottle activity analytics (`/get_scans`, `/get_num_scans`), tasting notes (`/get_reviews`, `/add_review`), and global leaderboard rankings.
  * **Interaction Handling:** Engineered transactional endpoints for community engagement, supporting dynamic upvoting and downvoting mechanics on published tasting notes (`/like_review`, `/unlike_review`).
  * **Cross-Origin Configuration:** Integrated Flask-CORS middleware to enable local multi-platform previewing and API communication across device emulators and web runtimes.
* **Tech Stack:** Python 3, Flask, Flask-CORS, RESTful API Design.

### Database Architecture & Gamification Triggers (MySQL)
*Design of a normalized relational schema with automated SQL triggers enforcing business logic and dynamic gamification rewards.*

* **Key Tasks:**
  * **Relational Schema Design (`schema.sql`, `insert.sql`):** Defined relational entities spanning user accounts, wine catalogs, timestamped scanning history (`scans`), reviews, and composite-key reaction mappings (`likedReviews`) with referential integrity (`ON DELETE CASCADE`).
  * **Automated Scoring Triggers:** Authored database triggers (`addLike`, `removeLike`) to dynamically adjust review upvote totals and synchronize community reward points to author profiles upon engagement.
  * **Rating Recalculation & Discovery Rewards:** Configured event triggers (`EditWineScore`) to automatically update catalog-wide average bottle scores upon review submission (+10 Sage Points), alongside discovery incentives (`FirstScan`) awarding bonus points (+5 Sage Points) for indexing new entries.
* **Tech Stack:** MySQL, Relational Schema Modeling, SQL Triggers & Procedures.

## Technologies Used

* **Languages:** Dart, Python 3, SQL
* **Frameworks & Libraries:** Flutter, Flask, Flask-CORS, mysql-connector-python
* **Database:** MySQL
* **Tools & Environments:** Android Studio, VS Code, Git
* **Core Concepts:** Human-Computer Interaction (HCI), User-Centered Design (UCD), Mobile UI/UX, RESTful Web Services, Relational Database Modeling, Database Triggers, Gamification Systems
