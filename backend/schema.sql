CREATE DATABASE IF NOT EXISTS HCI_db;

USE HCI_db;

CREATE TABLE IF NOT EXISTS users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(150) NOT NULL,
    passwd VARCHAR(150) NOT NULL,
    firstname VARCHAR(150) NOT NULL,
    surname VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    sage_points INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE (username),
    UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS wines (
    wine_name VARCHAR(150) PRIMARY KEY,
    wine_info TEXT,
    wine_score double DEFAULT 0
);

CREATE TABLE IF NOT EXISTS scans (
    scan_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(150) NOT NULL,
    wine_name VARCHAR(150) NOT NULL,
    last_view TIMESTAMP NOT NULL,
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (wine_name) REFERENCES wines(wine_name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
    review_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    review TEXT,
    username VARCHAR(150) NOT NULL,
    wine_name VARCHAR(150) NOT NULL,
    posted_on DATE DEFAULT DATE(NOW()) NOT NULL,
    likes INT UNSIGNED NOT NULL DEFAULT 0,
    score DOUBLE UNSIGNED NOT NULL,
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (wine_name) REFERENCES wines(wine_name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS likedReviews (
    username VARCHAR(150),
    review_id INT UNSIGNED,
    PRIMARY KEY (username, review_id),
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (review_id) REFERENCES reviews(review_id) ON DELETE CASCADE ON UPDATE CASCADE
);

delimiter //
CREATE TRIGGER addLike BEFORE INSERT ON likedReviews
       FOR EACH ROW
       BEGIN
           UPDATE reviews SET likes = likes+1 WHERE review_id = NEW.review_id;
           UPDATE users SET sage_points = sage_points +1 WHERE username = (SELECT username FROM reviews WHERE review_id = NEW.review_id);
       END;//
delimiter ;

delimiter //
CREATE TRIGGER removeLike BEFORE DELETE ON likedReviews
       FOR EACH ROW
       BEGIN
           UPDATE reviews SET likes = likes-1 WHERE review_id = old.review_id;
           UPDATE users SET sage_points = sage_points -1 WHERE username = (SELECT username FROM reviews WHERE review_id = OLD.review_id);
       END;//
delimiter ;

delimiter //
CREATE TRIGGER EditWineScore AFTER INSERT ON reviews
       FOR EACH ROW
       BEGIN
           UPDATE wines
           SET wine_score = (
               SELECT AVG(score)
               FROM reviews
               WHERE wine_name = NEW.wine_name
           )
           WHERE wine_name = NEW.wine_name;

           UPDATE users
           SET sage_points = sage_points + 10
           WHERE username = NEW.username;
       END;//
delimiter ;


delimiter //
CREATE TRIGGER FirstScan AFTER INSERT ON scans
    FOR EACH ROW
    BEGIN
        DECLARE scan_count INT;
        SET scan_count = (SELECT COUNT(*) FROM scans WHERE wine_name = NEW.wine_name);
        IF scan_count = 1 THEN
            UPDATE users SET sage_points = sage_points + 5 WHERE username = NEW.username;
        END IF;
    END;//
delimiter ;